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
1. Observe that agent logs include the error message: `[Process] PTY output copy failed with error: *errors.errorString: io: read/write on closed pipe`
    - expected to see no errors

Expected observations were determined by running the above steps, but using `./start-default-agent.sh` to start the agent.
