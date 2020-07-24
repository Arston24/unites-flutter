// Следует использовать для наименования реальные имена таблиц
Map<String, String> createTables = {
  'events': """CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
          eventId TEXT,
          name TEXT,
          description TEXT,
          company TEXT,
          phoneNumber TEXT,
          email TEXT,
          address TEXT,
          coordinates TEXT,
          start start,
          end TEXT,
          UNIQUE(eventId)
       );""",
  'participants': """CREATE TABLE participants (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      docId TEXT,
	      eventId TEXT,
	      userId TEXT,
	      role TEXT,
	      UNIQUE(docId)
	      );""",
  'users': """CREATE TABLE users (
	      id INTEGER PRIMARY KEY AUTOINCREMENT,
	      userId TEXT,
	      firstName TEXT,
	      lastName TEXT,
	      interests TEXT,
	      useful TEXT,
	      company TEXT,
	      token TEXT,
	      aboutMe TEXT,
	      UNIQUE(userId)
	      );""",
};
