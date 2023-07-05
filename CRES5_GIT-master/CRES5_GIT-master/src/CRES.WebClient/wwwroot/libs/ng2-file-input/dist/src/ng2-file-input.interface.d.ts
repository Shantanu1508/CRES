export interface Ng2FileInputOptionsInterface {
    dropText?: string;
    browseText?: string;
    removeText?: string;
    invalidFileText?: string;
    invalidFileTimeout?: number;
    removable?: boolean;
    multiple?: boolean;
    showPreviews?: boolean;
    extensions?: string[];
}
export declare class Ng2FileInputOptions implements Ng2FileInputOptionsInterface {
    dropText: string;
    browseText: string;
    removeText: string;
    invalidFileText: string;
    invalidFileTimeout: number;
    removable: boolean;
    multiple: boolean;
    showPreviews: boolean;
    extensions: string[];
}
export interface FileInput {
    id: string;
    currentFiles: File[];
}
