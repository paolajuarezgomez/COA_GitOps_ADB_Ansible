//go:build unit
// +build unit

package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestStaticSiteValidity(t *testing.T) {
	t.Parallel()
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../.",
	})
	output := terraform.InitAndPlan(t, terraformOptions)
	assert.Contains(t, output, "3 to add, 0 to change, 0 to destroy")
}
