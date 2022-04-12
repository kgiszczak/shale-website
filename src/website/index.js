import ace from 'ace-builds';
import 'ace-builds/src-noconflict/theme-monokai';
import 'ace-builds/src-noconflict/mode-ruby';
import 'ace-builds/src-noconflict/mode-sh';
import 'ace-builds/src-noconflict/mode-json';
import 'ace-builds/src-noconflict/mode-yaml';
import 'ace-builds/src-noconflict/mode-xml';
import './runtime';
import './index.css';

import exampleDataToRubyJson from './snippets/example-data-to-ruby/json.rb';
import exampleDataToRubyYaml from './snippets/example-data-to-ruby/yaml.rb';
import exampleDataToRubyXml from './snippets/example-data-to-ruby/xml.rb';
import exampleDataToRubyHash from './snippets/example-data-to-ruby/hash.rb';

import exampleRubyToDataJson from './snippets/example-ruby-to-data/json.rb';
import exampleRubyToDataYaml from './snippets/example-ruby-to-data/yaml.rb';
import exampleRubyToDataXml from './snippets/example-ruby-to-data/xml.rb';
import exampleRubyToDataHash from './snippets/example-ruby-to-data/hash.rb';

import exampleCustomMappingJson from './snippets/example-custom-mapping/json.rb';
import exampleCustomMappingYaml from './snippets/example-custom-mapping/yaml.rb';
import exampleCustomMappingHash from './snippets/example-custom-mapping/hash.rb';

import exampleCustomMappingXml from './snippets/example-custom-mapping-xml/xml.rb';

import exampleXmlNamespaces1 from './snippets/example-xml-namespaces/xml1.rb';
import exampleXmlNamespaces2 from './snippets/example-xml-namespaces/xml2.rb';

import exampleUsingMethodsJson from './snippets/example-using-methods/json.rb';
import exampleUsingMethodsYaml from './snippets/example-using-methods/yaml.rb';
import exampleUsingMethodsXml from './snippets/example-using-methods/xml.rb';

ace.config.setModuleUrl(
  'ace/mode/json_worker',
  require('file-loader?esModule=false!ace-builds/src-noconflict/worker-json.js'),
);

ace.config.setModuleUrl(
  'ace/mode/xml_worker',
  require('file-loader?esModule=false!ace-builds/src-noconflict/worker-xml.js'),
);

function run(outputEditor, codeEditor) {
  let code = `
    $webout = []
    global_constants = Object.constants

    begin
      def p(obj)
        $webout << (obj || '').inspect
      end

      def puts(obj)
        $webout << (obj || '').to_s
      end

      def pp(obj)
        buffer = []
        PP.pp(obj, buffer)
        $webout << buffer.join('')
      end

      ${codeEditor.getValue()}
    rescue => exc
      puts exc.message
    end

    (Object.constants - global_constants).each do |const|
      Object.send(:remove_const, const.to_s)
    end

    $webout
  `;

  outputEditor.setValue('', 1);

  return new Promise(resolve => {
    setTimeout(() => {
      outputEditor.setValue(Opal.eval(code).join('\n'), 1);
      resolve();
    }, 100);
  });
}

function createEditor(section) {
  const element = section.querySelector('.code');
  const copy = section.querySelector('.copy-to-clipboard');
  const readOnly = element.classList.contains('code-readonly');
  const showGutter = element.classList.contains('code-with-gutter');

  const editor = ace.edit(element, {
    mode: `ace/mode/${element.dataset.mode}`,
    theme: 'ace/theme/monokai',
    tabSize: 2,
    useSoftTabs: true,
    showPrintMargin: false,
    readOnly,
    showGutter: showGutter,
    highlightActiveLine: !readOnly,
    highlightGutterLine: !readOnly,
  });

  if (readOnly) {
    editor.renderer.$cursorLayer.element.style.opacity = 0;
  }

  if (copy) {
    copy.addEventListener('click', (ev) => {
      ev.preventDefault();
      copy.classList.add('success');
      const value = editor.getValue();
      navigator.clipboard.writeText(value.trim() + '\n');
      setTimeout(() => {
        copy.classList.remove('success');
      }, 1000);
    });
  }

  editor.on('changeMode', (ev) => {
    const mode = ev.mode.$id.split('/').pop();
    element.dataset.mode = mode;
  });

  return editor;
}

function initExample(exampleId, defaultMode, examples) {
  const codeEl = document.querySelector(`${exampleId} .code-section-editor`);
  const outputEl = document.querySelector(`${exampleId} .code-section-output`);

  const codeEditor = createEditor(codeEl);
  const outputEditor = createEditor(outputEl, true);

  function selectMode(mode) {
    const example = examples[mode];
    codeEditor.setValue(example.snippet, 1);
    outputEditor.session.setMode(`ace/mode/${example.outputMode}`);
    run(outputEditor, codeEditor);
  }

  selectMode(defaultMode)

  const tabs = document.querySelectorAll(`${exampleId} .example-group a`);

  tabs.forEach(tab => {
    tab.addEventListener('click', (ev) => {
      ev.preventDefault();
      tabs.forEach(e => e.classList.remove('active-example'));
      ev.target.classList.add('active-example');
      selectMode(ev.target.dataset.mode);
    });
  });

  document.querySelector(`${exampleId} .run-button`).addEventListener('click', (ev) => {
    ev.preventDefault();
    ev.target.classList.add('progress');

    run(outputEditor, codeEditor).then(() => {
      ev.target.classList.remove('progress');
    });
  });
}

window.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.code-section').forEach(el => {
    createEditor(el, true);
  });

  initExample('#example-data-to-ruby', 'json', {
    json: { snippet: exampleDataToRubyJson, outputMode: 'ruby' },
    yaml: { snippet: exampleDataToRubyYaml, outputMode: 'ruby' },
    xml: { snippet: exampleDataToRubyXml, outputMode: 'ruby' },
    ruby: { snippet: exampleDataToRubyHash, outputMode: 'ruby' },
  });

  initExample('#example-ruby-to-data', 'json', {
    json: { snippet: exampleRubyToDataJson, outputMode: 'json' },
    yaml: { snippet: exampleRubyToDataYaml, outputMode: 'yaml' },
    xml: { snippet: exampleRubyToDataXml, outputMode: 'xml' },
    ruby: { snippet: exampleRubyToDataHash, outputMode: 'ruby' },
  });

  initExample('#example-custom-mapping', 'json', {
    json: { snippet: exampleCustomMappingJson, outputMode: 'json' },
    yaml: { snippet: exampleCustomMappingYaml, outputMode: 'yaml' },
    ruby: { snippet: exampleCustomMappingHash, outputMode: 'ruby' },
  });

  initExample('#example-custom-mapping-xml', 'xml', {
    xml: { snippet: exampleCustomMappingXml, outputMode: 'xml' },
  });

  initExample('#example-xml-namespaces', 'xml1', {
    xml1: { snippet: exampleXmlNamespaces1, outputMode: 'ruby' },
    xml2: { snippet: exampleXmlNamespaces2, outputMode: 'ruby' },
  });

  initExample('#example-using-methods', 'json', {
    json: { snippet: exampleUsingMethodsJson, outputMode: 'ruby' },
    yaml: { snippet: exampleUsingMethodsYaml, outputMode: 'ruby' },
    xml: { snippet: exampleUsingMethodsXml, outputMode: 'ruby' },
  });
});