CREATE TABLE IF NOT EXISTS project (
    id INTEGER PRIMARY KEY,
    project_path TEXT NOT NULL UNIQUE,
    project_name TEXT NOT NULL,
    image_tag TEXT
);
CREATE TABLE IF NOT EXISTS cloud (
    id INTEGER UNIQUE DEFAULT(1),
    namespace TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS runtime_vars (
    id INTEGER UNIQUE DEFAULT(1),
    project_path TEXT,
    namespace TEXT,
    logo_view TEXT,
    banner_view TEXT
);