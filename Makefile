init-aws:
	aws cloudformation deploy --template-file website.cfn.yaml --stack-name shalerb-website

deploy: build
	aws s3 cp dist s3://www.shalerb.org --recursive
	aws cloudfront create-invalidation --distribution-id E1ZYY0483EHU3 --paths "/index.html" > /dev/null

build: runtime
	rm -rf dist
	webpack build --mode production

runtime: clone-shale bundle
	cd runtime && opal -c --no-source-map -I shale/lib -I stubs runtime.rb > ../src/runtime.js

clone-shale:
	cd runtime && (git -C shale pull || git clone https://github.com/kgiszczak/shale.git shale)

bundle:
	cd runtime && bundle
