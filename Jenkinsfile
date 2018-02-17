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
          }
        }

        stage('Build Windows x86_64') {
          agent {
            label "x86"
          }
          steps {
            sh '''
              PATH=$(echo "$PATH" | sed -e 's/:\\/mnt.*//g')
              cd depends
              make HOST=x86_64-w64-mingw32
              cd ..
              ./autogen.sh
              ./configure --prefix=`pwd`/depends/x86_64-w64-mingw32 --enable-asm --enable-static --disable-shared
              make -j2
              make check
            '''
          }
        }

        stage('Build Windows i686') {
          agent {
            label "x86"
          }
          steps {
            sh '''
              PATH=$(echo "$PATH" | sed -e 's/:\\/mnt.*//g') # strip out problematic Windows %PATH% imported var
              cd depends
              make HOST=i686-w64-mingw32
              cd ..
              ./autogen.sh
              ./configure --prefix=`pwd`/depends/i686-w64-mingw32 --enable-asm --enable-static --disable-shared
              make -j2
              make check
            '''
          }
        }
      }
    }
  }
}
