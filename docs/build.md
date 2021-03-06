# Building mulang from source

## Setup

To generate `mulang` executable, you have to build the project using [stack](https://haskellstack.org):

1. Install stack: `wget -qO- https://get.haskellstack.org/ | sh`
2. Go to the mulang project directory and setup it: `stack setup`
4. Build the project:
    1. If you need a production ready build, run `./build.sh`
    2. If you just need a quick-to-compile development version, run `./build.sh --fast`

## Installing and creating an executable


```bash
# This will generate a `mulang` executable in the folder `~/.local/bin`.
$ stack install
# Run mulang
$ mulang
```

## Running tests

```bash
# This will build the project and run rspec and hspec tests
$ ./test.sh
```

## Watching changes


```bash
# This will build the project and run rspec and hspec tests, and wait for changes in hspec tests
$ ./test.sh --file-watch
```

## Ruby wrapper

> See [`gem/README`](https://github.com/mumuki/mulang/blob/master/gem/README.md) for more details.

### Building

> :warning: You will need Ruby 2.3+.

```bash
cd gem
# install ruby
bundle install
# wrap gem and run rspec tests
rake
```

### Loading

Run `bin/console` in the `gem` directory.

## JavaScript library

> See [`ghcjslib/README`](https://github.com/mumuki/mulang/blob/master/ghcjslib/README.md) and [https://www.npmjs.com/package/mulang](https://www.npmjs.com/package/mulang) for more details.

`mulang` can also be compiled to JavaScript library using [ghcjs](https://github.com/ghcjs/ghcjs) and [ghcjslib](https://github.com/flbulgarelli/ghcjslib), which allows you to use it from `node` or the browser.

### Building

> :warning: you will need `node >= 7` installed on your system. If you have `nvm`, before starting run the following:
>
> ```sh
> $ nvm use $(cat ghcjslib/.nvmrc)
>```

```bash
# 1. Swap to GHCJS compiler
ghcjslib/swap.sh
# 2. Build ghcjslib release. It will be placed on ghcjslib/build/mulang.js
ghcjslib/build.sh
# 3. Run both mocha and hspec tests.
ghcjslib/test.sh
# 4. Run again for swapping back to ghc
ghcjslib/swap.sh
```

### Loading

1. in the browser: `google-chrome ghcjslib/index.html`
2. in `node`: run `node`, and then, within the interpreter, run: `let mulang = require('./ghcjslib/build/mulang.js');`

# Updating docs

These site is build using `mkdocs >= 0.17`. You can install it using  `pip`:

```bash
$ pip install mkdocs
```

From the project root folder, running `./docs/devinit` will setup the docs, `./docs/devstart` start the site locally, and `mkdocs gh-deploy` will deploy the documentation.
