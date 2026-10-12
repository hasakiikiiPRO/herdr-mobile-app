package domain

import "testing"

func TestEnrichTabLabels(t *testing.T) {
	snap := &Snapshot{
		Tabs: []Tab{
			{TabID: "w4:t20", Label: "test"},
			{TabID: "w4:t2E", Label: "8"},
		},
		Agents: []Agent{
			{PaneID: "w4:p20", TabID: "w4:t20", Agent: "pi"},
			{PaneID: "w4:p2E", TabID: "w4:t2E", Agent: "pi"},
			{PaneID: "w4:p99", TabID: "missing", Agent: "pi"},
			{PaneID: "w4:pKeep", TabID: "w4:t20", TabLabel: "kept", Agent: "pi"},
		},
		Panes: []Pane{
			{PaneID: "w4:p20", TabID: "w4:t20"},
			{PaneID: "w4:p2E", TabID: "w4:t2E"},
		},
	}
	snap.EnrichTabLabels()
	if snap.Agents[0].TabLabel != "test" {
		t.Fatalf("agent0 tab_label=%q want test", snap.Agents[0].TabLabel)
	}
	if snap.Agents[1].TabLabel != "8" {
		t.Fatalf("agent1 tab_label=%q want 8", snap.Agents[1].TabLabel)
	}
	if snap.Agents[2].TabLabel != "" {
		t.Fatalf("missing tab should stay empty, got %q", snap.Agents[2].TabLabel)
	}
	if snap.Agents[3].TabLabel != "kept" {
		t.Fatalf("pre-set tab_label overwritten: %q", snap.Agents[3].TabLabel)
	}
	if snap.Panes[0].TabLabel != "test" || snap.Panes[1].TabLabel != "8" {
		t.Fatalf("pane labels = %q %q", snap.Panes[0].TabLabel, snap.Panes[1].TabLabel)
	}
}
