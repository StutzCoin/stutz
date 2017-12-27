node('x86') {
  stage('Checkout') {
    checkout scm
  }

  stage('Configure') {
    sh '''
      ./autogen.sh

      export CPPFLAGS='-I/usr/local/BerkeleyDB.4.8/include'
      export LDFLAGS='-L/usr/local/BerkeleyDB.4.8/lib'
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
