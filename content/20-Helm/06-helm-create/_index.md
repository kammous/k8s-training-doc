+++
menutitle = "Create"
date = 2018-12-29T17:15:52Z
weight = 6
chapter = false
pre = "<b>- </b>"
+++

# Helm `Create`

With `create` command , we can create a standard helm directory/file structure which can be modified for our package.

```
$ helm create mychart
```

```
$ tree mychart/
```

```
mychart/
├── Chart.yaml         # A YAML file containing information about the chart.
├── charts             # A directory containing any charts upon which this chart depends.
├── templates          # A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.
│   ├── NOTES.txt      # A plain text file containing short usage notes.
│   ├── _helpers.tpl   # Also called "partials" that can be embedded into existing files while a Chart is being installed.
│   ├── deployment.yaml # A deployment spec
│   ├── ingress.yaml    # An ingress spec
│   ├── service.yaml    # An service spec
│   └── tests  
│       └── test-connection.yaml # A pod definition , that can be executed to test the Chart(https://github.com/helm/helm/blob/master/docs/chart_tests.md)
└── values.yaml         # The default configuration values for this chart

3 directories, 8 files
```
