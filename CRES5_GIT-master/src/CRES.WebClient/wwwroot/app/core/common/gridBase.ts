'use strict';

import {Component, EventEmitter, Inject, Input, ViewChild, AfterViewInit } from '@angular/core';

import * as wjcCore from 'wijmo/wijmo';
import * as wjcGrid from 'wijmo/wijmo.grid';

// Base class for all components demonstrating FlexGrid control.
@Component({
    selector: '',
    templateUrl: ''
})

export abstract class GridBase implements AfterViewInit {
    private _itemCount = 500;
    private _culture = 'en';
    private _dataMaps = true;
    private _formatting = true;
    private _filter = '';
    private _toFilter: any;
    private _thisFilterFunction: wjcCore.IPredicate;
    private _groupBy = '';
    
    data: any[];
    // references FlexGrid named 'flex' in the view
    @ViewChild('flex') flex: wjcGrid.FlexGrid;

    // DataSvc will be passed by derived classes
    constructor() {
        this._thisFilterFunction = this._filterFunction.bind(this);
    }

    get itemCount(): number {
        return this._itemCount;
    }
    set itemCount(value: number) {
        if (this._itemCount != value) {
            this._itemCount = value;
            this.groupBy = '';
        }
    }

    get dataMaps(): boolean {
        return this._dataMaps;
    }
    set dataMaps(value: boolean) {
        if (this._dataMaps != value) {
            this._dataMaps = value;
            this._updateDataMaps();
        }
    }

    get formatting(): boolean {
        return this._formatting;
    }
    set formatting(value: boolean) {
        if (this._formatting != value) {
            this._formatting = value;
            this._updateFormatting();
        }
    }

    get culture(): string {
        return this._culture;
    }
    set culture(value: string) {
        if (this._culture != value) {
            this._culture = value;
            this._loadCultureInfo();
        }
    }

    get filter(): string {
        return this._filter;
    }
    set filter(value: string) {
        if (this._filter != value) {
            this._filter = value;
            this._applyFilter();
        }
    }

    get groupBy(): string {
        return this._groupBy;
    }
    set groupBy(value: string) {
        if (this._groupBy != value) {
            this._groupBy = value;
            this._applyGroupBy();
        }
    }

    /*
    get pageSize(): number {
        return this._pageSize;
    }
    set pageSize(value: number) {
        if (this._pageSize != value) {
            this._pageSize = value;
            if (this.flex) {
                (<wijmo.collections.IPagedCollectionView>this.flex.collectionView).pageSize = value;
            }
        }
    }
    */
    ngAfterViewInit() {
        alert('Hi.222222')
        if (this.flex) {
            alert('Hi.44444')
            this.updateDataMapSettings();
        }
    }

    // update data maps, formatting, paging now and when the itemsSource changes
    itemsSourceChangedHandler() {
        var flex = this.flex;
        if (!flex) {
            return;
        }

        // make columns 25% wider (for readability and to show how)
        for (var i = 0; i < flex.columns.length; i++) {
            flex.columns[i].width = flex.columns[i].renderSize * 1.25;
        }

        // update data maps and formatting
        this.updateDataMapSettings();

        // set page size on the grid's internal collectionView
        /*
        if (flex.collectionView && this.pageSize) {
            (<wijmo.collections.IPagedCollectionView>flex.collectionView).pageSize = this.pageSize;
        }
        */
    };

    updateDataMapSettings() {
        this._updateDataMaps();
        this._updateFormatting();
    }

    toggleColumnVisibility() {
        var flex = this.flex;
        var col = flex.columns[0];
        col.visible = !col.visible;
    };
    changeColumnSize() {
        var flex = this.flex;
        var col = flex.columns[0];
        col.visible = true;
        col.width = col.width < 0 ? 60 : -1;
        col = flex.rowHeaders.columns[0];
        col.width = col.width < 0 ? 40 : -1;
    };
    toggleRowVisibility() {
        var flex = this.flex;
        var row = flex.rows[0];
        row.visible = !row.visible;
    };
    changeRowSize() {
        var flex = this.flex;
        var row = flex.rows[0];
        row.visible = true;
        row.height = row.height < 0 ? 80 : -1;
        row = flex.columnHeaders.rows[0];
        row.height = row.height < 0 ? 80 : -1;
    };
    changeDefaultRowSize() {
        var flex = this.flex;
        flex.rows.defaultSize = flex.rows.defaultSize == 28 ? 65 : 28;
    };
    changeScrollPosition() {
        var flex = this.flex;
        if (flex.scrollPosition.y == 0) {
            var sz = flex.scrollSize;
            flex.scrollPosition = new wjcCore.Point(-sz.width / 2, -sz.height / 2);
        } else {
            flex.scrollPosition = new wjcCore.Point(0, 0);
        }
    };


    // apply/remove data maps
    private _updateDataMaps() {
        var flex = this.flex;       
    }

    // build a data map from a string array using the indices as keys
    private _buildDataMap(items): wjcGrid.DataMap {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            map.push({ key: i, value: items[i] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    }

    // apply/remove column formatting
    private _updateFormatting() {
        var flex = this.flex;
        if (flex) {
            alert('Hi.666666')
            var fmt = this.formatting;
            this._setColumnFormat('AppReceived', fmt ? 'MMM d yy' : null);
            //this._setColumnFormat('amount', fmt ? 'c' : null);
            //this._setColumnFormat('amount2', fmt ? 'c' : null);
            //this._setColumnFormat('discount', fmt ? 'p0' : null);
            this._setColumnFormat('start', fmt ? 'MMM d yy' : null);
            //this._setColumnFormat('end', fmt ? 'HH:mm' : null);
        }
    }
    private _setColumnFormat(name, format) {
        var col = this.flex.columns.getColumn(name);
        if (col) {
            col.format = format;
        }
    }

    private _loadCultureInfo() {
        $.ajax({
            url: 'scripts/vendor/wijmo.culture.' + this.culture + '.js',
            dataType: 'script',
            success: function (data) {
                wjcCore.Control.invalidateAll(); // invalidate all controls to show new culture
            },
        });
    }

    // ICollectionView filter function
    private _filterFunction(item) {
        var f = this.filter;
        if (f && item) {

            // split string into terms to enable multi-field searches such as 'us gadget red'
            var terms = f.toUpperCase().split(' ');

            // look for any term in any string field
            for (var i = 0; i < terms.length; i++) {
                var termFound = false;
                for (var key in item) {
                    var value = item[key];
                    if (wjcCore.isString(value) && value.toUpperCase().indexOf(terms[i]) > -1) {
                        termFound = true;
                        break;
                    }
                }

                // fail if any of the terms is not found
                if (!termFound) {
                    return false;
                }
            }
        }

        // include item in view
        return true;
    }

    // apply filter (applied on a 500 ms timeOut)
    private _applyFilter() {
        if (this._toFilter) {
            clearTimeout(this._toFilter);
        }
        var self = this;
        this._toFilter = setTimeout(function () {
            self._toFilter = null;
            if (self.flex) {
                var cv = self.flex.collectionView;
                if (cv) {
                    if (cv.filter != self._thisFilterFunction) {
                        cv.filter = self._thisFilterFunction;
                    } else {
                        cv.refresh();
                    }
                }
            }
        }, 500);
    }

    private _applyGroupBy() {
        if (this.flex) {

            // get the collection view, start update
            var cv = this.flex.collectionView;
            cv.beginUpdate();

            // clear existing groups
            cv.groupDescriptions.clear();

            // add new groups
            var groupNames = this.groupBy.split('/'),
                groupDesc;
            for (var i = 0; i < groupNames.length; i++) {
                var propName = groupNames[i].toLowerCase();
                if (propName == 'amount') {

                    // group amounts in ranges
                    // (could use the mapping function to group countries into continents, 
                    // names into initials, etc)
                    groupDesc = new wjcCore.PropertyGroupDescription(propName, function (item, prop) {
                        var value = item[prop];
                        if (value > 1000) return 'Large Amounts';
                        if (value > 100) return 'Medium Amounts';
                        if (value > 0) return 'Small Amounts';
                        return 'Negative';
                    });
                    cv.groupDescriptions.push(groupDesc);
                } else if (propName) {

                    // group other properties by their specific values
                    groupDesc = new wjcCore.PropertyGroupDescription(propName);
                    cv.groupDescriptions.push(groupDesc);
                }
            }

            // done updating
            cv.endUpdate();
        }
    }


}
