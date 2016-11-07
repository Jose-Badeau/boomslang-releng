#!/bin/bash
# Sample Usage: buildProducts.sh $TRAVIS_BUILD_DIR 4.7.0 1.0.0
###############################################
API=https://api.bintray.com
BUILD_DIR=$1
WFS_VERSION=$2
BOOMSLANG_VERSION=$3
###############################################

function main(){
  buildProducts
}

function buildProducts() {
  echo "$@"
  echo "${BUILD_DIR}"
  echo "${WFS_VERSION}"
  echo "${BOOMSLANG_VERSION}"

  echo "Create directory structures..."
  cd $BUILD_DIR
  mkdir -p target/products
  cd target/products

  echo "Clone gut repos..."
  git clone https://github.com/Jose-Badeau/boomslang-geb.git
  git clone https://github.com/Jose-Badeau/boomslang-core.git
  git clone https://github.com/Jose-Badeau/boomslang-wireframesketcher

  echo "Build boomslang-wireframesketcher..."
  cd boomslang-wireframesketcher
  git checkout release/${WFS_VERSION}
  mvn clean deploy --settings $BUILD_DIR/settings.xml
  cd com.wireframesketcher.model.repository.remote
  mvn clean deploy --settings $BUILD_DIR/settings.xml

  echo "Build boomslang-core..."
  cd ../../boomslang-core
  git checkout release/${BOOMSLANG_VERSION}
  mvn clean deploy --settings $BUILD_DIR/settings.xml

  echo "Build boomslang-geb..."
  cd ../boomslang-geb
  git checkout release/${BOOMSLANG_VERSION}
  mvn clean deploy --settings $BUILD_DIR/settings.xml

  cd $BUILD_DIR
  echo "Done!"
}

main "$@"