require 'opal/full'
require 'opal-parser'
require 'native'
require 'template'
require 'ostruct'

class String
  def dump
    "\"#{self}\""
  end
end

module Opal
  module ERB
    class Compiler
      def find_contents(result)
        result = result
          .gsub(/\n\s+<%-/, '<%')
          .gsub(/\n<%-/, '<%')
          .gsub(/<%-/, '<%')
          .gsub(/-%>/, '%>')

        result.gsub(/<%=([\s\S]+?)%>/) do
          inner = Regexp.last_match(1).gsub(/\\'/, "'").gsub(/\\"/, '"')

          if inner =~ BLOCK_EXPR
            "\")\noutput_buffer.append= #{inner}\noutput_buffer.append(\""
          else
            "\")\noutput_buffer.append=(#{inner})\noutput_buffer.append(\""
          end
        end
      end
    end
  end
end

class ERB
  def initialize(source, trim_mode: nil)
    @id = rand(99999).to_s
    template = Opal::ERB.compile(source, @id)
    `eval(#{template})`
  end

  def result(bnd)
    context = OpenStruct.new

    bnd.local_variables.each do |var|
      context[var] = bnd.local_variable_get(var)
    end

    Template[@id].render(context)
  end
end

require 'shale'
require 'shale/schema'
require 'pp'

`
function formatXml(xml) {
  const NODE_PATTERN = /\s*<[^>\/]*>[^<>]*<\/[^>]*>|\s*<.+?>|\s*[^<]+/g;
  const indent = '  ';
  let tabs = '';

  return xml.replace(NODE_PATTERN, (m, i) => {
    m = m.replace(/^\s+|\s+$/g, '');

    if (i < 38) {
      if (/^<[?]xml/.test(m)) return m + '\n';
    }

    if (/^<[/]/.test(m)) {
      tabs = tabs.replace(indent, '');
      m = tabs + m;
    } else if (/<.*>.*<\/.*>|<.*[^>]\/>/.test(m)) {
      m = m.replace(/(<[^\/>]*)><[\/][^>]*>/g, '$1 />');
      m = tabs + m;
    } else if (/<.*>/.test(m)) {
      m = tabs + m;
      tabs += indent;
    } else {
      m = tabs + m;
    }

    return m + '\n';
  });
}
`

module Adapter
  module DOMParser
    def self.load(xml)
      doc = `new DOMParser().parseFromString(xml, 'application/xml')`
      Node.new(`doc.documentElement`)
    end

    def self.dump(doc, *options)
      result = ''

      if options.include?(:declaration)
        result += '<?xml version="1.0"?>'
      end

      result += `new XMLSerializer().serializeToString(doc)`

      if options.include?(:pretty)
        `return formatXml(result)`
      else
        result
      end
    end

    def self.create_document
      Document.new
    end

    class Document
      def initialize
        @doc = `new Document()`
        @namespaces = {}
      end

      def doc
        if `#@doc.documentElement`
          @namespaces.each do |prefix, namespace|
            `#@doc.documentElement.setAttribute('xmlns:' + prefix, namespace)`
          end
        end

        @doc
      end

      def create_element(name)
        `#@doc.createElement(name)`
      end

      def add_namespace(prefix, namespace)
        @namespaces[prefix] = namespace if prefix && namespace
      end

      def add_attribute(element, name, value)
        `element.setAttribute(name, value)`
      end

      def add_element(element, child)
        `element.appendChild(child)`
      end

      def add_text(element, text)
        `element.appendChild(#@doc.createTextNode(text))`
      end
    end

    class Node
      def initialize(node)
        @node = node
      end

      def namespaces
        nsps = {}

        attributes.each do |key, value|
          result = key.rpartition(':')
          nsp = result[0]
          name = result[-1]

          if nsp == 'http://www.w3.org/2000/xmlns/'
            nsps[name] = value
          end
        end

        nsps
      end

      def name
        %x{
          if (#@node.namespaceURI) {
            return #@node.namespaceURI + ':' + #@node.localName;
          } else {
            return #@node.localName;
          }
        }
      end

      def attributes
        %x{
          Array.from(#@node.attributes).map(e => {
            let name = e.localName;

            if (e.namespaceURI) {
              name = e.namespaceURI + ':' + e.localName;
            }

            return [name, e.value]
          })
        }.to_h
      end

      def children
        `Array.from(#@node.childNodes).filter(e => e.nodeType === 1)`.map { |e| self.class.new(e) }
      end

      def parent
        parent = `#@node.parentNode`
        is_document = `parent instanceof Document`

        self.class.new(parent) if parent && !is_document
      end

      def text
        `const node = Array.from(#@node.childNodes).find(e => e.nodeType === 3)`
        (`node ? node.textContent : ''`).strip;
      end
    end
  end
end

module Adapter
  class JsJSON
    def self.load(json)
      ::JSON.parse(json)
    end

    def self.dump(obj, *options)
      if options.include?(:pretty)
        `JSON.stringify(#{obj.to_n}, null, 2)`
      else
        `JSON.stringify(#{obj.to_n})`
      end
    end
  end
end

module Adapter
  class JsYAML
    def self.load(yaml)
      Hash.new(`jsyaml.load(yaml)`)
    end

    def self.dump(obj)
      `jsyaml.dump(#{obj.to_n})`
    end
  end
end

Shale.xml_adapter = Adapter::DOMParser
Shale.json_adapter = Adapter::JsJSON
Shale.yaml_adapter = Adapter::JsYAML
