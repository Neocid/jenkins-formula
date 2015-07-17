jenkins-safe-restart:
  cmd.wait:
    - name: java -jar jenkins-cli.jar -s "http://127.0.0.1:{{ port }}" safe-restart
    - cwd: /var/cache/jenkins/war/WEB-INF/
    - user: jenkins