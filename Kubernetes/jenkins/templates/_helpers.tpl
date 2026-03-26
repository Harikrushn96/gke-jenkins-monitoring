{{- define "jenkins.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "jenkins.labels" -}}
app.kubernetes.io/name: {{ include "jenkins.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "jenkins.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenkins.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
