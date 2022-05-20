package test

import (
	_ "github.com/mattn/go-sqlite3"
	"github.com/mindoc-org/mindoc/commands"
	"github.com/mindoc-org/mindoc/models"
	"testing"
)

func TestInsert(t *testing.T) {

	commands.RegisterModel()
	commands.RegisterDataBase()
	lr := models.NewLabelRelation()
	lr.RelationType = "book"
	lr.LabelId = 4
	lr.ResourceId = 0
	lr.SaveLabelRelation()
	t.Log("A")
}
