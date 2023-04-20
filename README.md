## Redmine WebHook Plugin
- A Redmine plugin posts webhook on creating and updating tickets.
- Redmine 4.0 or later
- see git@github.com:agileware-jp/redmine_banner.git

## Install
```shell
    cd $RAILS_ROOT/plugins
    git clone https://github.com/nomadli/redmine_webhook.git
    rake redmine:plugins:migrate RAILS_ENV=production
```
## data format
```golang
type NMLIRedmineField struct {
    ID    int64  `json:"id"`
	Name  string `json:"name"`
	Value string `json:"value"`
}

type NMLIRedmineProject struct {
    ID          int64  `json:"id"`
	Name        string `json:"name"`
	CreatedOn   string `json:"created_on"`
    UpdatedOn   string `json:"updated_on"`
	Identifier  string `json:"identifier"`
	Description string `json:"description"`
	Homepage    string `json:"homepage"`
}

type NMLIRedmineUser struct {
    ID          int64  `json:"id"`
	Login       string `json:"login"`
	Firstname   string `json:"firstname"`
	Lastname    string `json:"lastname"`
	Mail        string `json:"mail"`
	IconURL     string `json:"icon_url"`
    IdentityURL string `json:"identity_url"`
}

type NMLIRedmineIssue struct {
    ID              int64               `json:"id"`
	RootID          int64               `json:"root_id"`
	Private         bool                `json:"is_private"`
    Parent          NMLIRedmineField    `json:"parent"`
    Project         NMLIRedmineProject  `json:"project"`
    Tracker         NMLIRedmineField    `json:"tracker"`
	Status          NMLIRedmineField    `json:"status"`
    Priority        NMLIRedmineField    `json:"priority"`
    FixedVersion    NMLIRedmineField    `json:"fixed_version"`
	Author          NMLIRedmineUser     `json:"author"`
    Worker          NMLIRedmineUser     `json:"assigned_to"`
    DoneRatio       int64               `json:"done_ratio"`
	Description     string              `json:"description"`
	Subject         string              `json:"subject"`
	LockVersion     int64               `json:"lock_version"`
	StartDate       string              `json:"start_date"`
    DueDate         string              `json:"due_date"`
	EstiHours       float64             `json:"estimated_hours"`
	TotalEstiHours  float64             `json:"total_estimated_hours"`
	SpentHours      float64             `json:"spent_hours"`
	TotalSpentHours float64             `json:"total_spent_hours"`
	CreateDate      string              `json:"created_on"`
	UpdatedDate     string              `json:"updated_on"`
	CloseDate       string              `json:"closed_on"`
	Customs         []NMLIRedmineField  `json:"custom_fields"`
}

type NMLIRedmineDetail struct {
    ID          int64   `json:"id"`
    NValue      string `json:"value"`
    OValue      string `json:"prop_key"`
    PropKey     string `json:"old_value"`
    Property    string `json:"property"`
}

type NMLIRedmineJournal struct {
    ID          int64               `json:"id"`
	CreateDate  string              `json:"created_on"`
    Details     []NMLIRedmineDetail `json:"details"`
	Notes       string              `json:"notes"`
	Author      NMLIRedmineUser     `json:"author"`
	PNotes      bool                `json:"private_notes"`
}

```
## Issue opened
```json
    {
        "action": 1,
        "issue": "NMLIRedmineIssue{}",
        "url": "https://redmine.com/issue/1"
    }
```

## Issue updated
```json
    {
        "action": 2,
        "issue": "NMLIRedmineIssue{}",
        "journal": "NMLIRedmineJournal{}",
        "url": "https://redmine.com/issue/1"
    }
```

## Manual click
```json
    {
        "action": 3,
        "issue": "NMLIRedmineIssue{}",
        "user": "NMLIRedmineUser{}",
        "url": "https://redmine.com/issue/1"
    }
```

