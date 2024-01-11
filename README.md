# Shale Website

Landing page and interactive documentation for Shale -
JSON/YAML/XML mapper and serializer for Ruby.

Shale git repo is available at [GitHub](https://github.com/kgiszczak/shale)

This website is available at [www.shalerb.org](https://www.shalerb.org)

## Usage

This website is deployed as a static web page to S3 and configured with CloudFront CDN.

All the tasks are configured in Makefile, check it out for more details.

To deploy CloudFormation stack (configures S3 buckets, CloudFront CDN, certyficates and so on) use:

```
$ make init-aws
```

To build and deploy website use:

```
$ make deploy
```

To just build it use:

```
$ make build
```

To build runtime (Ruby side of the website) use:

```
$ make runtime
```

To vendor lates version of Shale gem use:

```
$ make clone-shale
```

To install all the dependencies required by runtime use:

```
$ make bundle
```
