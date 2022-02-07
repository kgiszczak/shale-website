require 'opal/full'
require 'opal-parser'
require 'native'
require 'shale'

module Adapter
  module DOMParser
    XSLT_STYLESHEET = <<~END
      <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
        <xsl:strip-space elements="*"/>
        <xsl:template match="para[content-style][not(text())]">
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:template>
        <xsl:template match="node()|@*">
          <xsl:copy><xsl:apply-templates select="node()|@*"/></xsl:copy>
        </xsl:template>
        <xsl:output indent="yes"/>
      </xsl:stylesheet>
    END

    def self.load(xml)
      doc = `new DOMParser().parseFromString(xml, 'application/xml')`
      Node.new(`doc.documentElement`)
    end

    def self.dump(doc)
      %x{
        const stylesheet = new DOMParser().parseFromString(#{XSLT_STYLESHEET}, 'application/xml');
        const xslt = new XSLTProcessor();
        xslt.importStylesheet(stylesheet);
        return new XMLSerializer().serializeToString(xslt.transformToDocument(doc))
      }
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

    def self.dump(obj)
      `JSON.stringify(#{obj.to_n}, null, 2)`
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

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class User < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :address, Address
end

user = User.from_json(<<~JSON)
{
  "first_name": "John",
  "last_name": "Doe",
  "address": {
    "city": "City",
    "street": "Street"
  }
}
JSON

user = User.from_xml(<<~XML)
  <user>
    <first_name>John</first_name>
    <last_name>Doe</last_name>
    <address>
      <city>City</city>
      <street>Street</street>
    </address>
  </user>
XML

user = User.from_yaml(<<~JSON)
---
  first_name: John
  last_name: Doe
  address:
    city: City
    street: Street
JSON

`let buffer = [];`

def p(obj)
  %x{
    const output = document.querySelector('#output');
    buffer.push(#{obj.inspect});
  }
end

def puts(obj)
  %x{
    const output = document.querySelector('#output');
    buffer.push(#{obj.to_s});
  }
end

%x{
  const button = document.querySelector('button');
  button.addEventListener('click', () => {
    buffer.length = 0;
    const val = document.querySelector('textarea').value;
    Opal.eval(val);
    output.innerText = buffer.join('\n');
  });
}
