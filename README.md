# reflekt-demo
A demo [Reflekt](https://github.com/GClunies/reflekt) project with examples how to:
1. Define schemas for event data collection.
2. Setup a CI/CD suite that can:

    | Trigger      | Run                 | Result                                                                                                                                                                                                 |
    |--------------|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
    | PR open/push | `reflekt lint`      | Lint schemas to ensure event and property naming convetions are followed. Check that required metadata is defined for events                                                                           |
    | PR merge     | `reflekt build dbt` | Build a dbt package that models and documents event data based on the schemas in a Reflekt project.<br> Create a git tag for the dbt package so it can be easily imported in a downstream dbt project. |
