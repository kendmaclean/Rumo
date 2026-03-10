# Rumo

A sequential Gantt-style task and bug tracker for solo developers, built with [Pharo](https://pharo.org) and [Bloc](https://github.com/pharo-graphics/Bloc).

Rumo schedules your tasks automatically — you define estimates, priorities, and dependencies, and the scheduler figures out when everything happens. No manual date entry required.

## Features

- **Sequential scheduler** — tasks are automatically ordered by priority and dependencies
- **Gantt chart** — visual timeline with calendar dates, dependency arrows, and a today marker
- **Inline dependency management** — right-click any task to add or remove multiple dependencies directly in the Gantt view
- **Tasks and bugs** — two item types with status (`open`, `inProgress`, `blocked`, `done`), priority (`low`, `medium`, `high`, `critical`), and estimates in days
- **Filter bar** — filter by title, type, status, priority, or estimate
- **Hide done** — toggle completed items out of the view
- **Undo** — 5-level deep-copy undo stack
- **Persistence** — auto-saves to STON on every change

## Requirements

- Bloc / Toplo (included via Metacello)

## Installation

Open a Pharo image and add Bloc/Toplo:

```
Library > Load Bloc and Toplo
```

open a **Playground**, and enter this:

```smalltalk
Metacello new
    baseline: 'Rumo';
    repository: 'github://kendmaclean/Rumo:master/src';
    load.
```

click DoIt.

## Running

```smalltalk
BgMainPresenter new open.
```

## Usage

| Action | How |
|---|---|
| Add task / bug | Toolbar buttons |
| Edit item | Select a row; edit in the details panel on the right |
| Add / remove dependencies | Right-click a bar → **Manage Dependencies**; click items to toggle (green = will add, red = will remove); click **Done** to confirm or **Escape** to cancel |
| Delete item | Right-click → Delete, or select + Delete key |
| Undo | Toolbar undo button |
| Hide completed items | Toolbar **Current** toggle |
| Filter | Filter bar at the top of the Gantt panel |

### Supported Pharo Versions

| Name | Smalltalk Version |
| ------------- | ------------- |
| Pharo | 12.0 | 
| Pharo | 13.0 | 

## License

MIT
