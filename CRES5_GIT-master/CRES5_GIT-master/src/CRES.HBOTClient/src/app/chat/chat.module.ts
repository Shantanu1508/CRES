import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { ChatService } from "./chat.service";
import { ChatDialogComponent } from "./chat-dialog/chat-dialog.component";
import { SpeechRecognitionService } from "../speech-recognition.service";
import { MaterialModule } from "../material-module";
import {
  MatAutocompleteModule,
  MatInputModule,
  MatProgressSpinnerModule,
  MatIconModule
} from "@angular/material";

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    MatAutocompleteModule,
    MatProgressSpinnerModule,
    MatInputModule,
    MatIconModule
  ],
  declarations: [ChatDialogComponent],
  exports: [ChatDialogComponent],
  providers: [ChatService, SpeechRecognitionService]
})
export class ChatModule {}
