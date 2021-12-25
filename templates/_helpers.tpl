{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins-inbound-agent-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins-inbound-agent-helm.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jenkins-inbound-agent-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jenkins-inbound-agent-helm.labels" -}}
helm.sh/chart: {{ include "jenkins-inbound-agent-helm.chart" . }}
{{ include "jenkins-inbound-agent-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jenkins-inbound-agent-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenkins-inbound-agent-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins-inbound-agent-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jenkins-inbound-agent-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the Secret Name
*/}}
{{- define "jenkins-inbound-agent-helm.secretName" -}}
{{- if .Values.jenkins.existingSecret -}}
    {{- printf "%s" .Values.jenkins.existingSecret -}}
{{- else if .Values.jenkins.secret -}}
    {{- printf "%s" ( include "jenkins-inbound-agent-helm.fullname" . ) -}}
{{- else -}}
{{- end -}}
{{- end -}}