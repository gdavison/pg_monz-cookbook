# Cookbook `pg_monz`

This cookbook installs [pg_monz](http://pg-monz.github.io/pg_monz/index-en.html) for monitoring PostgreSQL with Zabbix.

*NOTE*: Installs `pg_monz` v1

## Usage
The easiest way to use this cookbook is to call the `pg_monz::default` recipe, which calls the other recipes.

## Attributes
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['pg_monz']['version']</tt></td>
    <td>String</td>
    <td>Version of `pg_monz` to install</td>
    <td><tt>1.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['pg_monz']['hostname']</tt></td>
    <td>String</td>
    <td>Address of PostgreSQL server</td>
    <td><tt>127.0.0.1</tt></td>
  </tr>
  <tr>
    <td><tt>['pg_monz']['postgres_port']</tt></td>
    <td>Integer</td>
    <td>Port on PostgreSQL server</td>
    <td><tt>node['postgresql']['config']['port']</tt></td>
  </tr>
  <tr>
    <td><tt>['pg_monz']['database']</tt></td>
    <td>String</td>
    <td>Which databases to check</td>
    <td><tt>*</tt> (all databases)</td>
  </tr>
  <tr>
    <td><tt>['pg_monz']['username']</tt></td>
    <td>String</td>
    <td>Which database user to use for checks</td>
    <td><tt>postgres</tt></td>
  </tr>
</table>

## Recipes

### pg_monz::default
The default recipe downloads and installs `pg_monz`, then adds a `.pgpass` file to allow the zabbix user to access the PostgreSQL database.

### pg_monz::install
Downloads and installs `pg_monz`

### pg\_monz::zabbix\_user
Adds the `.pgpass` file to allow the zabbix user
