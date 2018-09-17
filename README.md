# Bamboo builds size metrics

A shell script providing metrics for Bamboo-builds size. Compatible with Nagios / Icinga / Grafana.

The prolonged use of Bamboo has an impact on free space and often also on performance.
Builds/deployments save their results and artifacts in directories, which can be deleted according to an schedule, individually or globally.
Bamboo does not offer a native way to get information about the projects and the size of each Build. This script lets you know the disk space used by each existing Bamboo plan. Metrics may be extracted from the output via Grafana.

The script simply queries the MySQL database (can be adapted to another engine) and gets the project name and plan identifier.
Then searches the hard drive (/opt/atlassian/bamboo/artifacts/ and /opt/atlassian/bamboo/xml-data/builds/) the directory and gets your disk space figures.

Having metrics of all the builds and being able to track the various builds is very useful, as well as just finding out the project and plan using the most disk space. 
The output is always in bytes.

### Syntax

```bash
./check_bamboo_size.sh mysql_user mysql_password mysql_db
```

### Example of output.
```
TeamRed_plan-233344088 = 201723007 TeamRed_plan-293782201 = 201718775 TeamBlue_plan-293784268 = 403436273 TeamBlue_plan-214993665 = 75273736
```
