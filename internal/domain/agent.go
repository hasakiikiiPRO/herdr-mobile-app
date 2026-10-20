package domain

// Agent represents an AI agent instance running in a terminal pane.
type Agent struct {
	Agent                 string `json:"agent"`
	AgentStatus           string `json:"agent_status"`
	DisplayAgent          string `json:"display_agent,omitempty"`
	Cwd                   string `json:"cwd"`
	Focused               bool   `json:"focused"`
	PaneID                string `json:"pane_id"`
	TabID                 string `json:"tab_id"`
	// TabLabel is the Herdr UI tab title (e.g. "test", "8"). Joined from
	// snapshot.tabs[].label by EnrichTabLabels — not present on raw agents.
	TabLabel              string `json:"tab_label,omitempty"`
	TerminalID            string `json:"terminal_id"`
	TerminalTitle         string `json:"terminal_title"`
	TerminalTitleStripped string `json:"terminal_title_stripped"`
	WorkspaceID           string `json:"workspace_id"`
}

// Workspace is a herdr workspace ("space"): a terminal project area holding
// tabs and panes (docs/10-herdr-api.md §6.1).
type Workspace struct {
	WorkspaceID string `json:"workspace_id"`
	Label       string `json:"label"`
	AgentStatus string `json:"agent_status"`
	TabCount    int    `json:"tab_count"`
	PaneCount   int    `json:"pane_count"`
	Focused     bool   `json:"focused"`
}

// Tab is a workspace tab; Label is the UI tab title shown in Herdr.
type Tab struct {
	TabID       string `json:"tab_id"`
	WorkspaceID string `json:"workspace_id"`
	Label       string `json:"label"`
	Number      int    `json:"number,omitempty"`
	PaneCount   int    `json:"pane_count,omitempty"`
	Focused     bool   `json:"focused,omitempty"`
	AgentStatus string `json:"agent_status,omitempty"`
}

// Pane is a terminal pane in a workspace — with an agent or a plain terminal.
type Pane struct {
	PaneID        string `json:"pane_id"`
	WorkspaceID   string `json:"workspace_id"`
	TabID         string `json:"tab_id"`
	TabLabel      string `json:"tab_label,omitempty"`
	Agent         string `json:"agent,omitempty"`
	AgentStatus   string `json:"agent_status"`
	Cwd           string `json:"cwd,omitempty"`
	TerminalTitle string `json:"terminal_title,omitempty"`
	Focused       bool   `json:"focused"`
}

// Snapshot is the complete herdr session snapshot: workspaces, panes, agents
// and the focused targets. `herdr api snapshot` returns exactly this shape
// (docs/10-herdr-api.md §6.1).
type Snapshot struct {
	Workspaces         []Workspace `json:"workspaces"`
	Tabs               []Tab       `json:"tabs,omitempty"`
	Panes              []Pane      `json:"panes"`
	Agents             []Agent     `json:"agents"`
	FocusedWorkspaceID string      `json:"focused_workspace_id,omitempty"`
	FocusedTabID       string      `json:"focused_tab_id,omitempty"`
	FocusedPaneID      string      `json:"focused_pane_id,omitempty"`
}

// EnrichTabLabels copies tabs[].label onto matching agents/panes as tab_label
// so mobile clients can show Herdr tab titles without a separate tabs join.
func (s *Snapshot) EnrichTabLabels() {
	if s == nil || len(s.Tabs) == 0 {
		return
	}
	byID := make(map[string]string, len(s.Tabs))
	for _, t := range s.Tabs {
		if t.TabID == "" || t.Label == "" {
			continue
		}
		byID[t.TabID] = t.Label
	}
	for i := range s.Agents {
		if s.Agents[i].TabLabel != "" {
			continue
		}
		if lab, ok := byID[s.Agents[i].TabID]; ok {
			s.Agents[i].TabLabel = lab
		}
	}
	for i := range s.Panes {
		if s.Panes[i].TabLabel != "" {
			continue
		}
		if lab, ok := byID[s.Panes[i].TabID]; ok {
			s.Panes[i].TabLabel = lab
		}
	}
}

// AgentOutput represents the terminal output of an agent.
type AgentOutput struct {
	Target string `json:"target"`
	Output string `json:"output"`
	// Revision is the pane's last known output revision (0 if unknown). It lets
	// clients skip re-rendering when their cached text already matches the
	// revision they saw in the last event.
	Revision int `json:"revision,omitempty"`
}


// PromoteUndetectedAgentPanes adds panes that look like running agents but are
// missing from agents[]. That happens when Claude is started via a wrapper that
// execs `claude.real` (process comm becomes claude.real): herdr never binds the
// pane, so it stays out of `herdr agent list` with agent_status=unknown — and the
// phone's first agent.prompt fails with agent_not_found. Promoting lets the app
// list them; send still goes through the unknown/pane path until herdr binds.
func (s *Snapshot) PromoteUndetectedAgentPanes() {
	if s == nil {
		return
	}
	have := make(map[string]struct{}, len(s.Agents))
	for _, a := range s.Agents {
		if a.PaneID != "" {
			have[a.PaneID] = struct{}{}
		}
	}
	for _, p := range s.Panes {
		if p.PaneID == "" {
			continue
		}
		if _, ok := have[p.PaneID]; ok {
			continue
		}
		kind := p.Agent
		if kind == "" {
			kind = inferAgentKindFromTitle(p.TerminalTitle)
		}
		if kind == "" {
			continue
		}
		status := p.AgentStatus
		if status == "" {
			status = "unknown"
		}
		title := p.TerminalTitle
		stripped := title
		if r, size := firstRune(title); size > 0 && isClaudeTitleMarker(r) {
			stripped = trimLeftSpace(title[size:])
		}
		s.Agents = append(s.Agents, Agent{
			Agent:                 kind,
			AgentStatus:           status,
			Cwd:                   p.Cwd,
			Focused:               p.Focused,
			PaneID:                p.PaneID,
			TabID:                 p.TabID,
			TabLabel:              p.TabLabel,
			TerminalTitle:         title,
			TerminalTitleStripped: stripped,
			WorkspaceID:           p.WorkspaceID,
		})
		have[p.PaneID] = struct{}{}
	}
}

func inferAgentKindFromTitle(title string) string {
	if title == "" {
		return ""
	}
	r, _ := firstRune(title)
	if isClaudeTitleMarker(r) {
		return "claude"
	}
	return ""
}

func isClaudeTitleMarker(r rune) bool {
	switch {
	case r == '✳' || r == '✻' || r == '✽' || r == '✶' || r == '✢' || r == '·':
		return true
	case r >= 0x2800 && r <= 0x28FF: // braille spinners
		return true
	case r >= 0x25D0 && r <= 0x25D3: // ◐◑◒◓
		return true
	default:
		return false
	}
}

func firstRune(s string) (rune, int) {
	for i, r := range s {
		return r, i + len(string(r))
	}
	return 0, 0
}

func trimLeftSpace(s string) string {
	for i := 0; i < len(s); i++ {
		if s[i] != ' ' && s[i] != '\t' {
			return s[i:]
		}
	}
	return ""
}
