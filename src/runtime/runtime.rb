require 'opal/full'
require 'opal-parser'
require 'native'
require 'shale'
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
      attr_reader :doc

      def initialize
        @doc = `new Document()`
      end

      def create_element(name)
        `#@doc.createElement(name)`
      end

      def add_namespace(prefix, namespace)
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

      def name
        `#@node.nodeName`
      end

      def attributes
        `Array.from(#@node.attributes).map(e => [e.name, e.value])`.to_h
      end

      def children
        `Array.from(#@node.childNodes).filter(e => e.nodeType === 1)`.map { |e| self.class.new(e) }
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
