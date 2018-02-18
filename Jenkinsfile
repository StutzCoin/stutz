pipeline {
  agent none
  stages {
    stage("Compile") {
      parallel {
        stage('Build Linux') {
          agent {
            label "x86"
          }
          steps {
            sh './autogen.sh'
            sh '''
              export BDB_PREFIX=/usr/local/BerkeleyDB.4.8

              ./configure \
                --enable-zmq \
                --with-gui=qt5 \
                --enable-glibc-back-compat \
                --enable-reduce-exports \
                --enable-static \
                CPPFLAGS=-DDEBUG_LOCKORDER \
                BDB_CFLAGS="-I${BDB_PREFIX}/include" \
                BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx"
            '''
            sh 'make clean'
            sh 'make -j2'
            sh 'make check'
          }
        }

        stage('Build Windows x86_64') {
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
          }
        }

        stage('Build Windows i686') {
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
          }
        }
        stage('Build macOS') {
          agent {
            label "macos-sierra"
          }
          steps {
            sh './autogen.sh'
            sh './configure
            sh 'make clean'
            sh 'make -j8'
            sh 'make check'
            sh 'make deploy'
          }
        }
      }
    }
  }
}
