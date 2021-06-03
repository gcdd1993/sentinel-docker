{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{- define "subchart.fullname" -}}
{{- $subChartName := index . 0 -}}
{{- $subChartValues := index . 1 -}}
{{- $global := index . 2 -}}
{{- default (printf "%s-%s" $global.Release.Name $subChartName) (default $subChartValues.nameOverride $subChartValues.fullnameOverride ) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dependencyHost" -}}
{{- $depName := index . 0 -}}
{{- $depObj := index . 1 -}}
{{- $global := index . 2 -}}
{{- $targetSvc := $depObj.target -}}

{{- range $key,$value := $targetSvc.services -}}
{{- if eq $key $depObj.name -}}
    {{- $svcObj:= $value }}
    {{- if $value.nameOverride -}}
        {{- $value.nameOverride -}}
    {{- else -}}
        {{- default (printf "%s-%s" $global.Release.Name $depName) $targetSvc.fullnameOverride }}-{{ $depObj.name }}
    {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "dependencyPort" -}}
{{- $depName := index . 0 -}}
{{- $depObj := index . 1 -}}
{{- $global := index . 2 -}}
{{- $targetSvc := $depObj.target -}}

{{- range $key,$value := $targetSvc.services -}}
{{- if eq $key $depObj.name -}}
    {{- $svcObj:= $value }}
    {{- $pNameWanted := default "default" $depObj.port }}
    {{- range $pName,$portObj := $value.ports -}}
        {{- if eq $pName $pNameWanted -}}
            {{- $portObj.port -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "serviceNameOf" -}}
{{- $chartName := index . 0 -}}
{{- $svcName := index . 1 -}}
{{- $base := index . 2 -}}
{{- $global := index . 3 -}}

{{- $svcObj := required (printf "service %s not exists" $svcName) (index $base.services $svcName ) }}
{{- default (printf "%s-%s" (include "subchart.fullname" (tuple $chartName $base $global)) $svcName) $svcObj.nameOverride -}}

{{- end -}}


{{- define "portNameOf" -}}
{{- $svcName := index . 0 -}}
{{- $portName := index . 1 -}}
{{- $base := index . 2 -}}
{{- $global := index . 3 -}}

{{- $svcObj := required (printf "service %s not exists" $svcName) (index $base.services $svcName ) -}}
{{- printf "%s-%s" (default $svcName $svcObj.nameOverride) $portName | trunc 15 | trimSuffix "-" -}}

{{- end -}}