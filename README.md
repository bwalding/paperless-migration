# Paperless Migration

This tooling assists in the migration from Mariner Software's Paperless to Paperless-NG.

## Naming

* MSP - Mariner Software Paperless
* PNGX - Paperless-NGX

## Status

* Basic migration works
* MSPL loses the Organization (should be straightforward to fix this - it is separate to Merchant inside SQLite)

## Motivation

Mariner software is apparently no longer business, and as such migrating away from this software is a priority (before it doesn't work after a system upgrade).

## Storage

### Mariner Software Paperless

MSP stores all attribute data in a SQLite database, and the related PDFs are stored on the filesystem in a date based layout.

See `receipts.sql` for the query we use to extract all the data.

### Paperless-NGX

PNGX offers a REST API to upload documents, correspondents, tags etc and configure them.

## Preparation

Backup everything and ensure you can recover in the event of a catastrophe.

The most likely issue is the migration tooling to terminate, leaving the most recent migration incomplete.  PNGX is fairly robust at restarting imports (skipping the previous one). However the metadata won't be updated. You are better off deleting everything and starting again.

## Approach

### Acquire list of migrations

Read the SQLite database and extract required metadata about each file that needs to be migrated.

### Verify

Verify that all files are currently in place in the MSPL archive.

Verify that all attributes have a target attribute in PLNG.
(we could set a mapping of attributes, and force the user to declare an attribute be dropped if they don't want it).

### Exclude

If the target already exists, skip the file. We will assume that the attributes are correct once the upload is done.  This might be a bad assumption.

### Move

Upload each file, setting all attributes on the target file.

Include the ID from the MSPL receipt (`Z_PK`) so we can find the location of the file on the target side.

### Attributes

See the verify section for some concepts here.


### Checkpoint

Once all files for a given day are complete, write a checkpoint file so we don't have to recheck that day.
