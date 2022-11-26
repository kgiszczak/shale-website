require 'opal/full'
require 'opal-parser'
require 'native'
require 'template'
require 'ostruct'

module URI
  class Generic
    attr_reader :host, :port, :path, :query, :fragment

    DEFAULT_PORTS = {
      'ftp' => 21,
      'http' => 80,
      'https' => 443,
      'ldap' => 389,
      'ldaps' => 636,
      'ws' => 80,
      'wss' => 443,
    }

    def initialize(
      scheme,
      userinfo,
      host,
      port,
      registry,
      path,
      opaque,
      query,
      fragment,
      parser = nil,
      arg_check = false
    )
      @scheme = scheme
      @userinfo = userinfo
      @host = host
      @port = port
      @path = path
      @query = query
      @fragment = fragment
      @user, @password = userinfo.split(/:/) if userinfo
    end

    def absolute?
      @scheme ? true : false
    end

    def relative?
      !absolute?
    end

    def merge(oth)
      rel = URI(oth)

      if rel.absolute?
        return rel
      end

      unless self.absolute?
        raise BadURIError, "both URI are relative"
      end

      base = self.dup

      authority = rel.userinfo || rel.host || rel.port

      if (rel.path.nil? || rel.path.empty?) && !authority && !rel.query
        base.fragment=(rel.fragment) if rel.fragment
        return base
      end

      base.query = nil
      base.fragment=(nil)

      if !authority
        base.set_path(merge_path(base.path, rel.path)) if base.path && rel.path
      else
        base.set_path(rel.path) if rel.path
      end

      base.set_userinfo(rel.userinfo) if rel.userinfo
      base.set_host(rel.host) if rel.host
      base.set_port(rel.port) if rel.port
      base.query = rel.query if rel.query
      base.fragment=(rel.fragment) if rel.fragment

      return base
    end

    def split_path(path)
      path.split("/", -1)
    end

    def merge_path(base, rel)
      base_path = split_path(base)
      rel_path  = split_path(rel)

      base_path += '' if base_path.last == '..'
      while i = base_path.index('..')
        base_path.slice!(i - 1, 2)
      end

      if (first = rel_path.first) and first.empty?
        base_path.clear
        rel_path.shift
      end

      rel_path.push('') if rel_path.last == '.' || rel_path.last == '..'
      rel_path.delete('.')

      tmp = []
      rel_path.each do |x|
        if x == '..' && !(tmp.empty? || tmp.last == '..')
          tmp.pop
        else
          tmp << x
        end
      end

      add_trailer_slash = !tmp.empty?
      if base_path.empty?
        base_path = ['']
      elsif add_trailer_slash
        base_path.pop
      end
      while x = tmp.shift
        if x == '..'
          base_path.pop if base_path.size > 1
        else
          base_path << x
          tmp.each {|t| base_path << t}
          add_trailer_slash = false
          break
        end
      end
      base_path.push('') if add_trailer_slash

      return base_path.join('/')
    end

    def split_userinfo(ui)
      return nil, nil unless ui
      user, password = ui.split(':', 2)

      return user, password
    end

    def set_userinfo(user, password = nil)
      unless password
        user, password = split_userinfo(user)
      end
      @user = user
      @password = password if password

      [@user, @password]
    end

    def set_host(v)
      @host = v
    end

    def set_port(v)
      v = v.empty? ? nil : v.to_i unless !v || v.kind_of?(Integer)
      @port = v
    end

    def set_path(v)
      @path = v
    end

    def query=(v)
      @query = v ? v : nil
    end

    def fragment=(v)
      @fragment = v ? v : nil
    end

    def userinfo
      if @user.nil?
        nil
      elsif @password.nil?
        @user
      else
        @user + ':' + @password
      end
    end

    def default_port
      nil
    end

    def to_s
      str = ''
      if @scheme
        str += @scheme
        str += ':'
      end

      if @opaque
        str += @opaque
      else
        if @host || %w[file postgres].include?(@scheme)
          str += '//'
        end
        if self.userinfo
          str += self.userinfo
          str += '@'
        end
        if @host
          str += @host
        end
        if @port && !@port.empty? && @port.to_i != DEFAULT_PORTS[@scheme]
          str += ':'
          str += @port.to_s
        end
        str += @path
        if @query
          str += '?'
          str += @query
        end
      end
      if @fragment
        str += '#'
        str += @fragment
      end
      str
    end
  end

  def self.parse(url)
    scheme, userinfo, host, port, registry, path, opaque, query, fragment = nil

    `
      try {
        const uri = new URL(url);

        if (uri.protocol) {
          scheme = uri.protocol.replace(':', '');
        }

        userinfo = (uri.username || '') + ':' + (uri.password || '');
        host = uri.hostname;
        port = uri.port;

        if (uri.pathname === '/') {
          path = '';
        } else {
          path = uri.pathname;
        }

        if (uri.search) {
          query = uri.search.replace('?', '');
        }

        if (uri.hash) {
          fragment = uri.hash.replace('#', '');
        }
      } catch {
        path = url;
      }
    `

    Generic.new(scheme, userinfo, host, port, registry, path, opaque, query, fragment)
  end
end

module Kernel
  def URI(uri)
    if uri.is_a?(URI::Generic)
      uri
    elsif uri = String.try_convert(uri)
      URI.parse(uri)
    else
      raise ArgumentError,
        "bad argument (expected URI object or URI string)"
    end
  end
  module_function :URI
end

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

  const result = xml.replace(NODE_PATTERN, (m, i) => {
    m = m.replace(/^\s+|\s+$/g, '');

    if (i < 38) {
      if (/^<[?]xml/.test(m)) return m + '\n';
    }

    if (/^<!/.test(m)) {
      tabs = tabs.replace(indent, '');
    } else if (/^<[/]/.test(m)) {
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

  return result.replace(/>\n<!/g, '><!');
}
`

module Adapter
  module DOMParser
    def self.load(xml)
      doc = `new DOMParser().parseFromString(xml, 'application/xml')`
      Node.new(`doc.documentElement`)
    end

    def self.dump(doc, pretty: false, declaration: false)
      result = ''

      if declaration
        result += '<?xml version="1.0"?>'
      end

      result += `new XMLSerializer().serializeToString(doc)`

      if pretty
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

      def create_cdata(text, parent)
        `parent.appendChild(#@doc.createCDATASection(text))`
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

    def self.dump(obj, pretty: false)
      if pretty
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
      data = `jsyaml.load(yaml)`

      if `Array.isArray(data)`
        data.map { |e| Hash.new(e) }
      else
        Hash.new(data)
      end
    end

    def self.dump(obj)
      `jsyaml.dump(#{obj.to_n})`
    end
  end
end

module Adapter
  class JsTOML
    def self.load(toml)
      Hash.new(`TOML.parse(toml)`)
    end

    def self.dump(obj)
      obj = obj.transform_values { |v| v.nil? ? '' : v }
      `TOML.stringify(#{obj.to_n})`
    end
  end
end

module Adapter
  class JsCSV
    def self.load(csv, headers:, **options)
      col_sep = options[:col_sep] || ','
      header_row = headers.join(col_sep)
      csv = "#{header_row}\n#{csv}".sub(/\n$/, '')
      data = `Papa.parse(csv, { header: true, delimiter: col_sep }).data`
      data.map { |e| Hash.new(e) }
    end

    def self.dump(obj, headers:, **options)
      col_sep = options[:col_sep] || ','
      `Papa.unparse(#{obj.to_n}, { header: false, delimiter: col_sep })`
    end
  end
end

Shale.xml_adapter = Adapter::DOMParser
Shale.json_adapter = Adapter::JsJSON
Shale.yaml_adapter = Adapter::JsYAML
Shale.toml_adapter = Adapter::JsTOML
Shale.csv_adapter = Adapter::JsCSV
