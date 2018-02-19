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
            sh 'CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/ --enable-threads=posix'
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
            sh 'CONFIG_SITE=$PWD/depends/i686-w64-mingw32/share/config.site ./configure --prefix=/ --enable-threads=posix'
            sh 'make clean'
            sh 'make -j2'
            sh 'make check'
          }
        }

        stage('Build macOS Cross') {
          agent {
            label "x86"
          }
          steps {
            sh 'cd depends && make HOST=x86_64-apple-darwin11'
            sh './autogen.sh'
            sh 'CONFIG_SITE=$PWD/depends/x86_64-apple-darwin11/share/config.site ./configure --prefix=/'
            sh 'make clean'
            sh 'make -j2'
            sh 'make check'
            sh 'make deploy'
          }
        }

        stage('Build macOS Native') {
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
