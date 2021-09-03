# buildkite-bootstrap-issue

Steps to reproduce:
1. Configure a Buildkite pipeline to build this repository using `pipeline.yml`.
1. Start an agent by running `BUILDKITE_AGENT_TOKEN=<xyz> ./start-bootstrapped-agent.sh`
1. Trigger a new build of the pipeline
1. After the command has been running for 10 seconds, click `Cancel` button for the step
1. Observe that [job output ends with line](https://buildkite.com/noizwaves/buildkite-bootstrap-issue/builds/6#47e59cea-13b3-4cc5-8d98-f3cfe3cbc3b6/15-17) `Received cancellation signal, interrupting`
    - expected to see lines:
    ```
    Terminated
    🚨 Error: The command was interrupted by a signal
    2021-09-03 16:43:13 DEBUG  Terminating bootstrap after cancellation with terminated
    ```
1. Observe that agent logs include the error message:
    ```
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [Process] Sending signal SIGTERM to PGID: 22 
    2021-09-03 22:05:04 INFO   bootstrapped-agent Process with PID: 22 finished with Exit Status: -1, Signal: SIGTERM 
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [JobRunner] Routine that refreshes the job has finished 
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [Process] Waiting for routines to finish 
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [LineScanner] Encountered EOF 
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [JobRunner] Routine that processes the log has finished 
    2021-09-03 22:05:04 DEBUG  bootstrapped-agent [LineScanner] Finished 
    2021-09-03 22:05:04 ERROR  bootstrapped-agent [Process] PTY output copy failed with error: *errors.errorString: io: read/write on closed pipe
    ```
    - expected to see
    ```
    2021-09-03 22:03:12 INFO   default-agent Canceling job b5fc6588-c773-46a1-9398-359be603bee0 with a grace period of 10s 
    2021-09-03 22:03:12 DEBUG  default-agent [Process] Sending signal SIGTERM to PGID: 24 
    2021-09-03 22:03:12 DEBUG  default-agent [Process] PTY has finished being copied to the buffer 
    2021-09-03 22:03:12 INFO   default-agent Process with PID: 24 finished with Exit Status: 255, Signal: nil
    ```

Expected observations were determined by running the above steps, but using `./start-default-agent.sh` to start the agent.
