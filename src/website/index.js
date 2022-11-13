import ace from 'ace-builds';
import 'ace-builds/src-noconflict/theme-monokai';
import 'ace-builds/src-noconflict/mode-ruby';
import 'ace-builds/src-noconflict/mode-sh';
import 'ace-builds/src-noconflict/mode-json';
import 'ace-builds/src-noconflict/mode-yaml';
import 'ace-builds/src-noconflict/mode-toml';
import 'ace-builds/src-noconflict/mode-xml';
import './runtime';
import './index.css';

import exampleDataToRubyJson from './snippets/example-data-to-ruby/json.rb';
import exampleDataToRubyYaml from './snippets/example-data-to-ruby/yaml.rb';
import exampleDataToRubyToml from './snippets/example-data-to-ruby/toml.rb';
import exampleDataToRubyCsv from './snippets/example-data-to-ruby/csv.rb';
import exampleDataToRubyXml from './snippets/example-data-to-ruby/xml.rb';
import exampleDataToRubyHash from './snippets/example-data-to-ruby/hash.rb';

import exampleRubyToDataJson from './snippets/example-ruby-to-data/json.rb';
import exampleRubyToDataYaml from './snippets/example-ruby-to-data/yaml.rb';
import exampleRubyToDataToml from './snippets/example-ruby-to-data/toml.rb';
import exampleRubyToDataCsv from './snippets/example-ruby-to-data/csv.rb';
import exampleRubyToDataXml from './snippets/example-ruby-to-data/xml.rb';
import exampleRubyToDataHash from './snippets/example-ruby-to-data/hash.rb';

import exampleCollectionsDataToRubyJson from './snippets/example-collections-data-to-ruby/json.rb';
import exampleCollectionsDataToRubyYaml from './snippets/example-collections-data-to-ruby/yaml.rb';
import exampleCollectionsDataToRubyCsv from './snippets/example-collections-data-to-ruby/csv.rb';
import exampleCollectionsDataToRubyHash from './snippets/example-collections-data-to-ruby/hash.rb';

import exampleCollectionsRubyToDataJson from './snippets/example-collections-ruby-to-data/json.rb';
import exampleCollectionsRubyToDataYaml from './snippets/example-collections-ruby-to-data/yaml.rb';
import exampleCollectionsRubyToDataCsv from './snippets/example-collections-ruby-to-data/csv.rb';
import exampleCollectionsRubyToDataHash from './snippets/example-collections-ruby-to-data/hash.rb';

import exampleCustomMappingJson from './snippets/example-custom-mapping/json.rb';
import exampleCustomMappingYaml from './snippets/example-custom-mapping/yaml.rb';
import exampleCustomMappingToml from './snippets/example-custom-mapping/toml.rb';
import exampleCustomMappingCsv from './snippets/example-custom-mapping/csv.rb';
import exampleCustomMappingHash from './snippets/example-custom-mapping/hash.rb';

import exampleCustomMappingXml from './snippets/example-custom-mapping-xml/xml.rb';
import exampleCdata from './snippets/example-cdata/xml.rb';

import exampleXmlNamespaces1 from './snippets/example-xml-namespaces/xml1.rb';
import exampleXmlNamespaces2 from './snippets/example-xml-namespaces/xml2.rb';

import exampleRenderingNilValuesJson from './snippets/example-rendering-nil-values/json.rb';
import exampleRenderingNilValuesYaml from './snippets/example-rendering-nil-values/yaml.rb';
import exampleRenderingNilValuesToml from './snippets/example-rendering-nil-values/toml.rb';
import exampleRenderingNilValuesCsv from './snippets/example-rendering-nil-values/csv.rb';
import exampleRenderingNilValuesXml from './snippets/example-rendering-nil-values/xml.rb';

import exampleUsingMethodsJson from './snippets/example-using-methods/json.rb';
import exampleUsingMethodsYaml from './snippets/example-using-methods/yaml.rb';
import exampleUsingMethodsToml from './snippets/example-using-methods/toml.rb';
import exampleUsingMethodsCsv from './snippets/example-using-methods/csv.rb';
import exampleUsingMethodsXml from './snippets/example-using-methods/xml.rb';

import exampleUsingMethodsContextJson from './snippets/example-using-methods-context/json.rb';

import exampleUsingMethodsGroupingJson from './snippets/example-using-methods-grouping/json.rb';
import exampleUsingMethodsGroupingXml from './snippets/example-using-methods-grouping/xml.rb';

import exampleAttributeDelegationJson from './snippets/example-attribute-delegation/json.rb';
import exampleAttributeDelegationYaml from './snippets/example-attribute-delegation/yaml.rb';
import exampleAttributeDelegationToml from './snippets/example-attribute-delegation/toml.rb';
import exampleAttributeDelegationCsv from './snippets/example-attribute-delegation/csv.rb';
import exampleAttributeDelegationXml from './snippets/example-attribute-delegation/xml.rb';

import exampleOnlyExceptOptionsRender from './snippets/example-only-except-options/render.rb';
import exampleOnlyExceptOptionsParse from './snippets/example-only-except-options/parse.rb';

import exampleCustomModelsRuby from './snippets/example-custom-models/ruby.rb';
import exampleCustomModelsJson from './snippets/example-custom-models/json.rb';

import exampleGeneratingSchemaJson from './snippets/example-generating-schema/json.rb';
import exampleGeneratingSchemaXml from './snippets/example-generating-schema/xml.rb';

import exampleGeneratingSchemaCustomTypesJson from './snippets/example-generating-schema-custom-types/json.rb';
import exampleGeneratingSchemaCustomTypesXml from './snippets/example-generating-schema-custom-types/xml.rb';

import exampleCompilingSchemaJson from './snippets/example-compiling-schema/json.rb';
import exampleCompilingSchemaXml from './snippets/example-compiling-schema/xml.rb';

import exampleAnonymousModuleJson from './snippets/example-anonymous-module/json.rb';

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
      try {
        outputEditor.setValue(Opal.eval(code).join('\n'), 1);
      } catch (error) {
        outputEditor.setValue(error.message, 1);
      }
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

  if (!codeEl) return;

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
  document.addEventListener('scroll', () => {
    const chapters = document.querySelectorAll('.header-anchor');
    const links = document.querySelectorAll(`.index-nav a`)

    let activeChapterId = null;

    chapters.forEach(el => {
      if (el.getBoundingClientRect().top < window.innerHeight / 3) {
        activeChapterId = el.href;
      }
    });

    links.forEach(el => {
      el.classList.remove('active');

      if (el.href === activeChapterId) {
        el.classList.add('active');
      }
    });
  });

  document.querySelectorAll('.code-section').forEach(el => {
    createEditor(el, true);
  });

  initExample('#example-data-to-ruby', 'json', {
    json: { snippet: exampleDataToRubyJson, outputMode: 'ruby' },
    yaml: { snippet: exampleDataToRubyYaml, outputMode: 'ruby' },
    toml: { snippet: exampleDataToRubyToml, outputMode: 'ruby' },
    csv: { snippet: exampleDataToRubyCsv, outputMode: 'ruby' },
    xml: { snippet: exampleDataToRubyXml, outputMode: 'ruby' },
    ruby: { snippet: exampleDataToRubyHash, outputMode: 'ruby' },
  });

  initExample('#example-ruby-to-data', 'json', {
    json: { snippet: exampleRubyToDataJson, outputMode: 'json' },
    yaml: { snippet: exampleRubyToDataYaml, outputMode: 'yaml' },
    toml: { snippet: exampleRubyToDataToml, outputMode: 'toml' },
    csv: { snippet: exampleRubyToDataCsv, outputMode: 'json' },
    xml: { snippet: exampleRubyToDataXml, outputMode: 'xml' },
    ruby: { snippet: exampleRubyToDataHash, outputMode: 'ruby' },
  });

  initExample('#example-collections-data-to-ruby', 'json', {
    json: { snippet: exampleCollectionsDataToRubyJson, outputMode: 'ruby' },
    yaml: { snippet: exampleCollectionsDataToRubyYaml, outputMode: 'ruby' },
    csv: { snippet: exampleCollectionsDataToRubyCsv, outputMode: 'ruby' },
    ruby: { snippet: exampleCollectionsDataToRubyHash, outputMode: 'ruby' },
  });

  initExample('#example-collections-ruby-to-data', 'json', {
    json: { snippet: exampleCollectionsRubyToDataJson, outputMode: 'json' },
    yaml: { snippet: exampleCollectionsRubyToDataYaml, outputMode: 'yaml' },
    csv: { snippet: exampleCollectionsRubyToDataCsv, outputMode: 'csv' },
    ruby: { snippet: exampleCollectionsRubyToDataHash, outputMode: 'ruby' },
  });

  initExample('#example-custom-mapping', 'json', {
    json: { snippet: exampleCustomMappingJson, outputMode: 'json' },
    yaml: { snippet: exampleCustomMappingYaml, outputMode: 'yaml' },
    toml: { snippet: exampleCustomMappingToml, outputMode: 'toml' },
    csv: { snippet: exampleCustomMappingCsv, outputMode: 'json' },
    ruby: { snippet: exampleCustomMappingHash, outputMode: 'ruby' },
  });

  initExample('#example-custom-mapping-xml', 'xml', {
    xml: { snippet: exampleCustomMappingXml, outputMode: 'xml' },
  });

  initExample('#example-cdata', 'xml', {
    xml: { snippet: exampleCdata, outputMode: 'xml' },
  });

  initExample('#example-xml-namespaces', 'xml1', {
    xml1: { snippet: exampleXmlNamespaces1, outputMode: 'ruby' },
    xml2: { snippet: exampleXmlNamespaces2, outputMode: 'ruby' },
  });

  initExample('#example-rendering-nil-values', 'json', {
    json: { snippet: exampleRenderingNilValuesJson, outputMode: 'ruby' },
    yaml: { snippet: exampleRenderingNilValuesYaml, outputMode: 'ruby' },
    toml: { snippet: exampleRenderingNilValuesToml, outputMode: 'ruby' },
    csv: { snippet: exampleRenderingNilValuesCsv, outputMode: 'ruby' },
    xml: { snippet: exampleRenderingNilValuesXml, outputMode: 'ruby' },
  });

  initExample('#example-using-methods', 'json', {
    json: { snippet: exampleUsingMethodsJson, outputMode: 'ruby' },
    yaml: { snippet: exampleUsingMethodsYaml, outputMode: 'ruby' },
    toml: { snippet: exampleUsingMethodsToml, outputMode: 'ruby' },
    csv: { snippet: exampleUsingMethodsCsv, outputMode: 'ruby' },
    xml: { snippet: exampleUsingMethodsXml, outputMode: 'ruby' },
  });

  initExample('#example-using-methods-context', 'json', {
    json: { snippet: exampleUsingMethodsContextJson, outputMode: 'json' },
  });

  initExample('#example-using-methods-grouping', 'json', {
    json: { snippet: exampleUsingMethodsGroupingJson, outputMode: 'ruby' },
    xml: { snippet: exampleUsingMethodsGroupingXml, outputMode: 'ruby' },
  });

  initExample('#example-attribute-delegation', 'json', {
    json: { snippet: exampleAttributeDelegationJson, outputMode: 'ruby' },
    yaml: { snippet: exampleAttributeDelegationYaml, outputMode: 'ruby' },
    toml: { snippet: exampleAttributeDelegationToml, outputMode: 'ruby' },
    csv: { snippet: exampleAttributeDelegationCsv, outputMode: 'ruby' },
    xml: { snippet: exampleAttributeDelegationXml, outputMode: 'ruby' },
  });

  initExample('#example-only-except-options', 'render', {
    render: { snippet: exampleOnlyExceptOptionsRender, outputMode: 'json' },
    parse: { snippet: exampleOnlyExceptOptionsParse, outputMode: 'ruby' },
  });

  initExample('#example-custom-models', 'ruby', {
    ruby: { snippet: exampleCustomModelsRuby, outputMode: 'ruby' },
    json: { snippet: exampleCustomModelsJson, outputMode: 'json' },
  });

  initExample('#example-generating-schema', 'json', {
    json: { snippet: exampleGeneratingSchemaJson, outputMode: 'json' },
    xml: { snippet: exampleGeneratingSchemaXml, outputMode: 'xml' },
  });

  initExample('#example-generating-schema-custom-types', 'json', {
    json: { snippet: exampleGeneratingSchemaCustomTypesJson, outputMode: 'json' },
    xml: { snippet: exampleGeneratingSchemaCustomTypesXml, outputMode: 'xml' },
  });

  initExample('#example-compiling-schema', 'json', {
    json: { snippet: exampleCompilingSchemaJson, outputMode: 'ruby' },
    xml: { snippet: exampleCompilingSchemaXml, outputMode: 'ruby' },
  });

  initExample('#example-release-v050-compiling-schema', 'xml', {
    xml: { snippet: exampleCompilingSchemaXml, outputMode: 'ruby' },
  });

  initExample('#example-release-v060-custom-models', 'ruby', {
    ruby: { snippet: exampleCustomModelsRuby, outputMode: 'ruby' },
    json: { snippet: exampleCustomModelsJson, outputMode: 'json' },
  });

  initExample('#example-release-v060-toml', 'ruby', {
    ruby: { snippet: exampleRubyToDataToml, outputMode: 'toml' },
    toml: { snippet: exampleDataToRubyToml, outputMode: 'ruby' },
  });

  initExample('#example-release-v060-cdata', 'ruby', {
    ruby: { snippet: exampleCdata, outputMode: 'xml' },
  });

  initExample('#example-release-v070-render-nil', 'ruby', {
    ruby: { snippet: exampleRenderingNilValuesJson, outputMode: 'json' },
  });

  initExample('#example-release-v070-only-except', 'render', {
    render: { snippet: exampleOnlyExceptOptionsRender, outputMode: 'json' },
    parse: { snippet: exampleOnlyExceptOptionsParse, outputMode: 'ruby' },
  });

  initExample('#example-release-v070-context', 'ruby', {
    ruby: { snippet: exampleUsingMethodsContextJson, outputMode: 'json' },
  });

  initExample('#example-release-v080-grouping', 'ruby', {
    ruby: { snippet: exampleUsingMethodsGroupingJson, outputMode: 'json' },
  });

  initExample('#example-release-v080-anonymous-module', 'ruby', {
    ruby: { snippet: exampleAnonymousModuleJson, outputMode: 'json' },
  });

  initExample('#example-release-v090-support-for-collections', 'ruby', {
    ruby: { snippet: exampleCollectionsRubyToDataJson, outputMode: 'json' },
  });

  initExample('#example-release-v090-support-for-csv', 'ruby', {
    ruby: { snippet: exampleDataToRubyCsv, outputMode: 'ruby' },
  });

  initExample('#example-release-v100-support-attribute-delegation', 'ruby', {
    ruby: { snippet: exampleAttributeDelegationJson, outputMode: 'ruby' },
  });
});
