export class NoteAdditionalPlus {


    PIKScheduleDetail_EffectiveDate: Date;
    listPIKScheduleDetail: Array<PIKScheduleDetail>;

    FeeCouponStrip_EffectiveDate: Date;
    listFeeCouponStrip: Array<FeeCouponStrip>;


    Libor_EffectiveDate: Date;
    listLibor: Array<Libor>;

    FixedAmort_EffectiveDate: Date;
    listFixedAmort: Array<FixedAmort>;

    FinancingSchedule_EffectiveDate: Date;
    listFinancingSchedule: Array<FinancingSchedule>;


    FutureFunding_EffectiveDate: Date;
    listFutureFunding: Array<FutureFunding>;
}

export class PIKScheduleDetail {
    Date: Date;
    Value: number;
}

export class FeeCouponStrip {
    Date: Date;
    Value: number;
}

export class Libor {
    Date: Date;
    Value: number;
}

export class FinancingSchedule {
    Date: Date;
    Value: number;
}


export class FixedAmort {
    Date: Date;
    Value: number;
}
export class FutureFunding {
    Date: Date;
    Value: number;   
}


