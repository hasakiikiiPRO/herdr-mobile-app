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

func TestPromoteUndetectedAgentPanes(t *testing.T) {
	snap := &Snapshot{
		Agents: []Agent{
			{PaneID: "w5:p1", Agent: "claude", AgentStatus: "idle"},
		},
		Panes: []Pane{
			{PaneID: "w5:p1", Agent: "claude", AgentStatus: "idle", TerminalTitle: "✳ already"},
			{PaneID: "w5:p15", AgentStatus: "unknown", Cwd: "/home/u/cc", TabID: "w5:t15", TabLabel: "7",
				TerminalTitle: "✳ GitHub fork", WorkspaceID: "w5"},
			{PaneID: "w5:p16", AgentStatus: "unknown", TerminalTitle: "◑ working title", WorkspaceID: "w5"},
			{PaneID: "w5:p99", AgentStatus: "unknown", TerminalTitle: "plain shell", WorkspaceID: "w5"},
		},
	}
	snap.PromoteUndetectedAgentPanes()
	if len(snap.Agents) != 3 {
		t.Fatalf("agents=%d want 3 (p1 + p15 + p16)", len(snap.Agents))
	}
	var p15 *Agent
	for i := range snap.Agents {
		if snap.Agents[i].PaneID == "w5:p15" {
			p15 = &snap.Agents[i]
		}
	}
	if p15 == nil {
		t.Fatal("w5:p15 not promoted")
	}
	if p15.Agent != "claude" || p15.AgentStatus != "unknown" || p15.TabLabel != "7" {
		t.Fatalf("promoted p15 = %+v", p15)
	}
	if p15.TerminalTitleStripped != "GitHub fork" {
		t.Fatalf("stripped=%q", p15.TerminalTitleStripped)
	}
}
