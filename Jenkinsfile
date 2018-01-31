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
    sh 'cat src/test/test_stutz.log'
    sh 'cat src/qt/test/test_stutz-qt.log'
  }

  stage ('Create Distribution') {
    sh 'mkdir -p dist/bin dist/lib dist/include'

    // binaries
    sh 'cp src/stutz-cli dist/bin/'
    sh 'cp src/qt/stutz-qt dist/bin/'
    sh 'cp src/stutz-tx dist/bin/'
    sh 'cp src/stutzd dist/bin/'
    sh 'cp src/test/test_stutz dist/bin/'

    // libraries
    sh 'cp src/.libs/libbitcoinconsensus.so dist/lib/'

    // create archive
    sh 'tar czf linux-amd64.tgz dist/'
  }

  stage ('Upload') {
    withCredentials([
        UsernamePasswordMultiBinding(credentialsId: 'digitalocean-spaces', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')
    ]) {
        sh 's3cmd put linux-amd64.tgz s3://stutz.ams3.digitaloceanspaces.com/${BRANCH}/dist/linux-amd64.tgz'
    }
  }
}
