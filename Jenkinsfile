pipeline {
  agent none
  environment {
    DISABLE_AUTH = 'true'
    DB_ENGINE    = 'sqlite'
    MAKEJOBS=-j2
    RUN_TESTS=false
    CHECK_DOC=0
    BOOST_TEST_RANDOM=1$BUILD_ID
    CCACHE_SIZE=100M
    CCACHE_TEMPDIR=/tmp/.ccache-temp
    CCACHE_COMPRESS=1
    BASE_OUTDIR=$WORKSPACE/out
    OUTDIR=$WORKSPACE/out
    SDK_URL="https://bitcoincore.org/depends-sources/sdks"
    PYTHON_DEBUG=1
    WINEDEBUG=fixme-all
    LITECOIN_SCRYPT=0
  }
  stages {
    stage("Compile") {
      parallel {
        stage('x86_64 Linux') {
          agent {
            label "x86"
          }
          steps {
            script {
              HOST=x86_64-unknown-linux-gnu
              BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"

              DEP_OPTS="NO_QT=1 NO_UPNP=1 DEBUG=1 ALLOW_HOST_PACKAGES=1"
              RUN_TESTS=true
              GOAL="install"
              BITCOIN_CONFIG="--enable-zmq --with-gui=qt5 --enable-glibc-back-compat --enable-reduce-exports --enable-sse2 CPPFLAGS=-DDEBUG_LOCKORDER"
              LITECOIN_SCRYPT=1

            }

            sh 'if [ "$CHECK_DOC" = 1 ]; then contrib/devtools/check-doc.py; fi'
            sh 'mkdir -p depends/SDKs depends/sdk-sources'
            sh 'if [ -n "$OSX_SDK" -a ! -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then curl --location --fail $SDK_URL/MacOSX${OSX_SDK}.sdk.tar.gz -o depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz; fi'
            sh 'if [ -n "$OSX_SDK" -a -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then tar -C depends/SDKs -xf depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz; fi'
            sh 'make $MAKEJOBS -C depends HOST=$HOST $DEP_OPTS'

            sh 'depends/$HOST/native/bin/ccache --max-size=$CCACHE_SIZE'

            sh './autogen.sh'

            sh 'mkdir build'
            cd build
            sh '../configure --cache-file=config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG || ( cat config.log && false)'

            sh 'make distdir VERSION=$HOST'

            cd stutz-$HOST

            sh './configure --cache-file=../config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG || ( cat config.log && false)'
            sh 'make $MAKEJOBS $GOAL || ( echo "Build failure. Verbose build follows." && make $GOAL V=1 ; false )'

            script {
              LD_LIBRARY_PATH=$WORKSPACE/depends/$HOST/lib
            }

            sh 'if [ "$RUN_TESTS" = "true" ]; then travis_wait 30 make $MAKEJOBS check VERBOSE=1; fi'
            sh 'if [ "$RUN_TESTS" = "true" ]; then test/functional/test_runner.py --coverage --quiet ${extended}; fi'
          }
        }

        stage('32-bit + Dash') {
          agent {
            label "x86"
          }
          steps {
            sh 'Not implememnted, yet"
          }
        }


        stage('x86_64 Linux, No wallet') {
          agent {
            label "x86"
          }
          steps {
            sh 'Not implememnted, yet"
          }
        }

        stage('ARM') {
          agent {
            label 'x86'
          }
          steps {
            sh 'Not implememnted, yet"
          }
        }

        stage('Win64') {
          agent {
            label "x86"
          }
          steps {
            sh 'cd depends && make HOST=x86_64-w64-mingw32'
            sh './autogen.sh'
            sh 'CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/'
            sh 'make clean'
            sh 'make -j2'
            sh 'make check'
            sh 'make deploy'
          }
        }

        stage('Win32') {
          agent {
            label "x86"
          }
          steps {
            sh 'cd depends && make HOST=i686-w64-mingw32'
            sh './autogen.sh'
            sh 'CONFIG_SITE=$PWD/depends/i686-w64-mingw32/share/config.site ./configure --prefix=/'
            sh 'make clean'
            sh 'make -j2'
            sh 'make check'
            sh 'make deploy'
          }
        }

        stage('Cross-Mac') {
          agent {
            label "x86"
          }
          steps {
            sh 'Not implememnted, yet"
          }
        }

        stage('macOS') {
          agent {
            label "macos-sierra"
          }
          steps {
            sh 'source ${HOME}/.bashrc && ./autogen.sh'
            sh 'source ${HOME}/.bashrc && ./configure'
            sh 'source ${HOME}/.bashrc && make clean'
            sh 'source ${HOME}/.bashrc && make -j8'
            sh 'source ${HOME}/.bashrc && make check'
            sh 'source ${HOME}/.bashrc && make deploy'
          }
        }
      }
    }
  }
}
