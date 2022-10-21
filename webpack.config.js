const path = require('path');
const ProvidePlugin = require('webpack').ProvidePlugin;
const HtmlWebpackPlugin = require('html-webpack-plugin');
const HtmlInlineScriptPlugin = require('html-inline-script-webpack-plugin');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  entry: './src/website/index.js',
  resolve: {
    fallback: { 'stream': false },
  },
  output: {
    publicPath: '',
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(json|yaml|xml|rb)$/,
        type: 'asset/source',
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/website/index.html',
      minify: false,
    }),
    new HtmlWebpackPlugin({
      template: 'src/website/releases.html',
      filename: 'releases.html',
      minify: false,
    }),
    new HtmlInlineScriptPlugin(),
    new ProvidePlugin({
      jsyaml: 'js-yaml',
      TOML: '@iarna/toml',
      Papa: 'papaparse',
    }),
  ],
  performance: {
    hints: false,
    maxAssetSize: 99999999,
  },
  optimization: {
    minimizer: [
      new TerserPlugin({
        extractComments: false,
      }),
    ],
  },
  devServer: {
    client: {
      overlay: false,
    },
  },
};
