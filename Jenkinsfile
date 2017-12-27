node('x86') {
  stage('Checkout') {
    checkout scm
  }

  stage('Configure') {
    sh './autogen.sh'
    sh './configure --enable-zmq --with-gui=qt5 --enable-glibc-back-compat --enable-reduce-exports CPPFLAGS=-DDEBUG_LOCKORDER'
  }

  stage('Build') {
    sh 'make -j2'
  }

  stage ('Check') {
    sh 'make check'
  }
}
