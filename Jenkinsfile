node('x86') {
  stage('Checkout') {
    checkout scm
  }

  stage('Configure') {
    sh '''
      export BDB_INCLUDE_PATH=/usr/local/BerkeleyDB.4.8/include
      export BDB_LIB_PATH=/usr/local/BerkeleyDB.4.8/lib
      ./autogen.sh
      ./configure --enable-zmq --with-gui=qt5 --enable-glibc-back-compat --enable-reduce-exports CPPFLAGS=-DDEBUG_LOCKORDER
    '''
  }

  stage('Build') {
    sh 'make -j2'
  }

  stage ('Check') {
    sh 'make check'
  }
}
