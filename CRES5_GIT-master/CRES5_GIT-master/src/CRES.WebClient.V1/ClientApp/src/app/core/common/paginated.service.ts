export class Paginated {
  public _pageSize: number = 0;
  public _pageIndex: number = 0;
  public _totalCount: number = 0;

  constructor(pageSize: number, pageIndex: number, totalCount: number) {
    this._pageSize = pageSize;
    this._pageIndex = pageIndex;
    this._totalCount = totalCount;
  }

  pagePlus(count: number): number {
    return + this._pageIndex + count;
  }


  search(i: any): void {
    this._pageIndex = i;
  };
}
