'use strict';
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GridBase = void 0;
var core_1 = require("@angular/core");
var wjcCore = require("wijmo/wijmo");
var wjcGrid = require("wijmo/wijmo.grid");
// Base class for all components demonstrating FlexGrid control.
var GridBase = /** @class */ (function () {
    // DataSvc will be passed by derived classes
    function GridBase() {
        this._itemCount = 500;
        this._culture = 'en';
        this._dataMaps = true;
        this._formatting = true;
        this._filter = '';
        this._groupBy = '';
        this._thisFilterFunction = this._filterFunction.bind(this);
    }
    Object.defineProperty(GridBase.prototype, "itemCount", {
        get: function () {
            return this._itemCount;
        },
        set: function (value) {
            if (this._itemCount != value) {
                this._itemCount = value;
                this.groupBy = '';
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(GridBase.prototype, "dataMaps", {
        get: function () {
            return this._dataMaps;
        },
        set: function (value) {
            if (this._dataMaps != value) {
                this._dataMaps = value;
                this._updateDataMaps();
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(GridBase.prototype, "formatting", {
        get: function () {
            return this._formatting;
        },
        set: function (value) {
            if (this._formatting != value) {
                this._formatting = value;
                this._updateFormatting();
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(GridBase.prototype, "culture", {
        get: function () {
            return this._culture;
        },
        set: function (value) {
            if (this._culture != value) {
                this._culture = value;
                this._loadCultureInfo();
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(GridBase.prototype, "filter", {
        get: function () {
            return this._filter;
        },
        set: function (value) {
            if (this._filter != value) {
                this._filter = value;
                this._applyFilter();
            }
        },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(GridBase.prototype, "groupBy", {
        get: function () {
            return this._groupBy;
        },
        set: function (value) {
            if (this._groupBy != value) {
                this._groupBy = value;
                this._applyGroupBy();
            }
        },
        enumerable: false,
        configurable: true
    });
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
    GridBase.prototype.ngAfterViewInit = function () {
        alert('Hi.222222');
        if (this.flex) {
            alert('Hi.44444');
            this.updateDataMapSettings();
        }
    };
    // update data maps, formatting, paging now and when the itemsSource changes
    GridBase.prototype.itemsSourceChangedHandler = function () {
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
    ;
    GridBase.prototype.updateDataMapSettings = function () {
        this._updateDataMaps();
        this._updateFormatting();
    };
    GridBase.prototype.toggleColumnVisibility = function () {
        var flex = this.flex;
        var col = flex.columns[0];
        col.visible = !col.visible;
    };
    ;
    GridBase.prototype.changeColumnSize = function () {
        var flex = this.flex;
        var col = flex.columns[0];
        col.visible = true;
        col.width = col.width < 0 ? 60 : -1;
        col = flex.rowHeaders.columns[0];
        col.width = col.width < 0 ? 40 : -1;
    };
    ;
    GridBase.prototype.toggleRowVisibility = function () {
        var flex = this.flex;
        var row = flex.rows[0];
        row.visible = !row.visible;
    };
    ;
    GridBase.prototype.changeRowSize = function () {
        var flex = this.flex;
        var row = flex.rows[0];
        row.visible = true;
        row.height = row.height < 0 ? 80 : -1;
        row = flex.columnHeaders.rows[0];
        row.height = row.height < 0 ? 80 : -1;
    };
    ;
    GridBase.prototype.changeDefaultRowSize = function () {
        var flex = this.flex;
        flex.rows.defaultSize = flex.rows.defaultSize == 28 ? 65 : 28;
    };
    ;
    GridBase.prototype.changeScrollPosition = function () {
        var flex = this.flex;
        if (flex.scrollPosition.y == 0) {
            var sz = flex.scrollSize;
            flex.scrollPosition = new wjcCore.Point(-sz.width / 2, -sz.height / 2);
        }
        else {
            flex.scrollPosition = new wjcCore.Point(0, 0);
        }
    };
    ;
    // apply/remove data maps
    GridBase.prototype._updateDataMaps = function () {
        var flex = this.flex;
    };
    // build a data map from a string array using the indices as keys
    GridBase.prototype._buildDataMap = function (items) {
        var map = [];
        for (var i = 0; i < items.length; i++) {
            map.push({ key: i, value: items[i] });
        }
        return new wjcGrid.DataMap(map, 'key', 'value');
    };
    // apply/remove column formatting
    GridBase.prototype._updateFormatting = function () {
        var flex = this.flex;
        if (flex) {
            alert('Hi.666666');
            var fmt = this.formatting;
            this._setColumnFormat('AppReceived', fmt ? 'MMM d yy' : null);
            //this._setColumnFormat('amount', fmt ? 'c' : null);
            //this._setColumnFormat('amount2', fmt ? 'c' : null);
            //this._setColumnFormat('discount', fmt ? 'p0' : null);
            this._setColumnFormat('start', fmt ? 'MMM d yy' : null);
            //this._setColumnFormat('end', fmt ? 'HH:mm' : null);
        }
    };
    GridBase.prototype._setColumnFormat = function (name, format) {
        var col = this.flex.columns.getColumn(name);
        if (col) {
            col.format = format;
        }
    };
    GridBase.prototype._loadCultureInfo = function () {
        $.ajax({
            url: 'scripts/vendor/wijmo.culture.' + this.culture + '.js',
            dataType: 'script',
            success: function (data) {
                wjcCore.Control.invalidateAll(); // invalidate all controls to show new culture
            },
        });
    };
    // ICollectionView filter function
    GridBase.prototype._filterFunction = function (item) {
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
    };
    // apply filter (applied on a 500 ms timeOut)
    GridBase.prototype._applyFilter = function () {
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
                    }
                    else {
                        cv.refresh();
                    }
                }
            }
        }, 500);
    };
    GridBase.prototype._applyGroupBy = function () {
        if (this.flex) {
            // get the collection view, start update
            var cv = this.flex.collectionView;
            cv.beginUpdate();
            // clear existing groups
            cv.groupDescriptions.clear();
            // add new groups
            var groupNames = this.groupBy.split('/'), groupDesc;
            for (var i = 0; i < groupNames.length; i++) {
                var propName = groupNames[i].toLowerCase();
                if (propName == 'amount') {
                    // group amounts in ranges
                    // (could use the mapping function to group countries into continents, 
                    // names into initials, etc)
                    groupDesc = new wjcCore.PropertyGroupDescription(propName, function (item, prop) {
                        var value = item[prop];
                        if (value > 1000)
                            return 'Large Amounts';
                        if (value > 100)
                            return 'Medium Amounts';
                        if (value > 0)
                            return 'Small Amounts';
                        return 'Negative';
                    });
                    cv.groupDescriptions.push(groupDesc);
                }
                else if (propName) {
                    // group other properties by their specific values
                    groupDesc = new wjcCore.PropertyGroupDescription(propName);
                    cv.groupDescriptions.push(groupDesc);
                }
            }
            // done updating
            cv.endUpdate();
        }
    };
    __decorate([
        core_1.ViewChild('flex'),
        __metadata("design:type", wjcGrid.FlexGrid)
    ], GridBase.prototype, "flex", void 0);
    GridBase = __decorate([
        core_1.Component({
            selector: '',
            templateUrl: ''
        }),
        __metadata("design:paramtypes", [])
    ], GridBase);
    return GridBase;
}());
exports.GridBase = GridBase;
//# sourceMappingURL=gridBase.js.map