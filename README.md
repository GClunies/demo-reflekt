# reflekt-demo
Demo [Reflekt](https://github.com/GClunies/reflekt) project.

This repo shows how to:
1. Define schemas for event data collection.
2. Setup a CI/CD suite that:
  - **On PR open/push:** Lint schemas to ensure event and property naming convetions are followed. Check that required metadata is defined for events.
  - **On PR merge:** Automatically builds a dbt package that models and documents event data based on the schemas in a Reflekt project. Ready for use in a downstream dbt project.
