.PHONY: init-aws
init-aws:
	aws cloudformation deploy --template-file website.cfn.yaml --stack-name shalerb-website

.PHONY: deploy
deploy: build
	aws s3 cp dist s3://www.shalerb.org --recursive
	aws cloudfront create-invalidation --distribution-id E1ZYY0483EHU3 --paths "/index.html" "/releases.html" > /dev/null

.PHONY: build
build: runtime
	rm -rf dist
	yarn webpack build --mode production

.PHONY: runtime
runtime: clone-shale bundle
	cd src/runtime && opal -c --no-source-map -I shale/lib -I stubs runtime.rb > ../website/runtime.js

.PHONY: clone-shale
clone-shale:
	cd src/runtime && (git -C shale pull || git clone https://github.com/kgiszczak/shale.git shale)

.PHONY: bundle
bundle:
	cd src/runtime && bundle
