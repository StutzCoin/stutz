def build_stutz() {
  sh "printenv"
  sh "rm -rf build/config.cache"
  sh "if [ \"${PACKAGES}\" != \" \" ]; then sudo apt-get install ${PACKAGES} -y; fi"
  sh "if [ \"$CHECK_DOC\" = 1 ]; then contrib/devtools/check-doc.py; fi"
  sh "mkdir -p depends/SDKs depends/sdk-sources"
  sh "if [ -n \"$OSX_SDK\" -a ! -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then curl --location --fail $SDK_URL/MacOSX${OSX_SDK}.sdk.tar.gz -o depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz; fi"
  sh "if [ -n \"$OSX_SDK\" -a -f depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then tar -C depends/SDKs -xf depends/sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz; fi"
  sh "make $MAKEJOBS -C depends HOST=$HOST $DEP_OPTS"
  sh "depends/$HOST/native/bin/ccache --max-size=$CCACHE_SIZE"
  sh "./autogen.sh"
  sh "mkdir -p build"
  sh "if test -f config.status; then make distclean; fi"
  dir("build") {
    sh "../configure --cache-file=config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG || ( cat config.log && false)"
    sh "make distdir VERSION=$HOST"
    dir("stutz-$HOST") {
      sh "./configure --cache-file=../config.cache $BITCOIN_CONFIG_ALL $BITCOIN_CONFIG || ( cat config.log && false)"
      sh "make $MAKEJOBS $GOAL || ( echo \"Build failure. Verbose build follows.\" && make $GOAL V=1 ; false )"
      sh "if [ \"$RUN_TESTS\" = \"true\" ]; then make $MAKEJOBS check VERBOSE=1; fi"
      sh "if [ \"$RUN_TESTS\" = \"true\" ]; then test/functional/test_runner.py --coverage --quiet ${extended}; fi"
    }
    archive "${OUTDIR}/**"
  }
}

pipeline {
  agent none
    environment {
      DISABLE_AUTH = 'true'
      DB_ENGINE    = 'sqlite'
      MAKEJOBS="-j2"
      RUN_TESTS="false"
      CHECK_DOC="0"
      BOOST_TEST_RANDOM="1$BUILD_ID"
      CCACHE_SIZE="100M"
      CCACHE_TEMPDIR="/tmp/.ccache-temp"
      CCACHE_COMPRESS="1"
      SDK_URL="https://bitcoincore.org/depends-sources/sdks"
      PYTHON_DEBUG="1"
      WINEDEBUG="fixme-all"
      LITECOIN_SCRYPT="0"
      OSX_SDK=" "
      BDB_PREFIX="/usr/local/BerkeleyDB.4.8"
      DEP_OPTS=" "
      extended=" " 
      PACKAGES="g++-multilib gcc-multilib"
    }
  stages {
    stage("Compile") {
      parallel {
        stage("ARM") {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="arm-linux-gnueabihf"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_QT=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-glibc-back-compat --enable-reduce-exports"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
            PACKAGES="gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf"
          }
          steps {
            build_stutz()
          }
        }

        stage("Win32") {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="i686-w64-mingw32"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_QT=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-reduce-exports"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }

        stage("32-bit") {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="i686-pc-linux-gnu"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_QT=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-zmq --enable-glibc-back-compat --enable-reduce-exports LDFLAGS=-static-libstdc++"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }

        stage("Win64") {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="x86_64-w64-mingw32"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_QT=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-reduce-exports --enable-sse2"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }

        stage('x86_64 Linux') {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="x86_64-unknown-linux-gnu"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_QT=1 NO_UPNP=1 DEBUG=0 ALLOW_HOST_PACKAGES=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-zmq --with-gui=qt5 --enable-glibc-back-compat --enable-reduce-exports --enable-sse2 CPPFLAGS=-DDEBUG_LOCKORDER"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }

        stage('x86_64 Linux, No wallet') {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="x86_64-unknown-linux-gnu"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            DEP_OPTS="NO_WALLET=1"
            GOAL="install"
            BITCOIN_CONFIG="--enable-glibc-back-compat --enable-reduce-exports --enable-sse2"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }


        stage('Cross-Mac') {
          agent {
            label "x86"
          }
          environment {
            BASE_OUTDIR="$WORKSPACE/out"
            OUTDIR="$WORKSPACE/out"
            HOST="x86_64-apple-darwin11"
            BITCOIN_CONFIG_ALL="--disable-dependency-tracking --prefix=$WORKSPACE/depends/$HOST --bindir=$OUTDIR/bin --libdir=$OUTDIR/lib"
            OSX_SDK=10.11
            GOAL="deploy"
            BITCOIN_CONFIG="--enable-gui --enable-reduce-exports --enable-sse2"
            LITECOIN_SCRYPT="1"
            STUTZ_SCRYPT="1"
            LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$WORKSPACE/depends/$HOST/lib"
          }
          steps {
            build_stutz()
          }
        }

        stage('macOS') {
          agent {
            label "macos-sierra"
          }
          steps {
            sh "printenv"
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