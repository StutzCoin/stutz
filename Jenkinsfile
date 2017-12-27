node('x86') {
  stage('Checkout') {
    checkout scm
  }

  stage('Configure') {
    sh '''
      ./autogen.sh

      export BDB_PREFIX=/usr/local/BerkeleyDB.4.8
      
      ./configure \
        --enable-zmq \
        --with-gui=qt5 \
        --enable-glibc-back-compat \
        --enable-reduce-exports \
        CPPFLAGS=-DDEBUG_LOCKORDER \
        BDB_CFLAGS="-I${BDB_PREFIX}/include" \
        BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx"
    '''
  }

  stage('Build') {
    sh 'make -j2'
  }

  stage ('Check') {
    sh 'make check'
  }
}
