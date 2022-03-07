import ace from 'ace-builds';
import 'ace-builds/src-noconflict/theme-monokai';
import 'ace-builds/src-noconflict/mode-ruby';
import 'ace-builds/src-noconflict/mode-sh';
import 'ace-builds/src-noconflict/mode-json';
import 'ace-builds/src-noconflict/mode-yaml';
import 'ace-builds/src-noconflict/mode-xml';
import './runtime';
import './index.css';

import example1Json from './snippets/example1/json.rb';
import example1Yaml from './snippets/example1/yaml.rb';
import example1Xml from './snippets/example1/xml.rb';
import example1Hash from './snippets/example1/hash.rb';

import example2Json from './snippets/example2/json.rb';
import example2Yaml from './snippets/example2/yaml.rb';
import example2Xml from './snippets/example2/xml.rb';
import example2Hash from './snippets/example2/hash.rb';

import example3Json from './snippets/example3/json.rb';
import example3Yaml from './snippets/example3/yaml.rb';
import example3Hash from './snippets/example3/hash.rb';

import example4Xml from './snippets/example4/xml.rb';

import example5Json from './snippets/example5/json.rb';
import example5Yaml from './snippets/example5/yaml.rb';
import example5Xml from './snippets/example5/xml.rb';

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
        $webout << obj.inspect
      end

      def puts(obj)
        $webout << obj.to_s
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

  initExample('#example-1', 'json', {
    json: { snippet: example1Json, outputMode: 'ruby' },
    yaml: { snippet: example1Yaml, outputMode: 'ruby' },
    xml: { snippet: example1Xml, outputMode: 'ruby' },
    ruby: { snippet: example1Hash, outputMode: 'ruby' },
  });

  initExample('#example-2', 'json', {
    json: { snippet: example2Json, outputMode: 'json' },
    yaml: { snippet: example2Yaml, outputMode: 'yaml' },
    xml: { snippet: example2Xml, outputMode: 'xml' },
    ruby: { snippet: example2Hash, outputMode: 'ruby' },
  });

  initExample('#example-3', 'json', {
    json: { snippet: example3Json, outputMode: 'json' },
    yaml: { snippet: example3Yaml, outputMode: 'yaml' },
    ruby: { snippet: example3Hash, outputMode: 'ruby' },
  });

  initExample('#example-4', 'xml', {
    xml: { snippet: example4Xml, outputMode: 'xml' },
  });

  initExample('#example-5', 'json', {
    json: { snippet: example5Json, outputMode: 'ruby' },
    yaml: { snippet: example5Yaml, outputMode: 'ruby' },
    xml: { snippet: example5Xml, outputMode: 'ruby' },
  });
});
