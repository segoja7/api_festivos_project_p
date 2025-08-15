import { Component, Inject } from '@angular/core';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { PaisEditarComponent } from '../pais-editar/pais-editar.component';
import { Tipo } from '../../../shared/entidades/tipo';

export interface DatosEdicionTipo {
  encabezado: string;
  tipo: Tipo;
}

@Component({
  selector: 'app-tipo-editar',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
    NgxDatatableModule,
  ],
  templateUrl: './tipo-editar.component.html',
  styleUrl: './tipo-editar.component.css'
})
export class TipoEditarComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public datos: DatosEdicionTipo,
    public dialogRef: MatDialogRef<TipoEditarComponent>,
  ) {

  }

  cerrar() {
    this.dialogRef.close();
  }
}
