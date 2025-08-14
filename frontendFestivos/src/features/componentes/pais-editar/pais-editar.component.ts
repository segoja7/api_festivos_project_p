import { Component, Inject } from '@angular/core';
import { Pais } from '../../../shared/entidades/pais';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';

export interface DatosEdicionPais {
  encabezado: string;
  pais: Pais;
}

@Component({
  selector: 'app-pais-editar',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
  ],
  templateUrl: './pais-editar.component.html',
  styleUrl: './pais-editar.component.css'
})
export class PaisEditarComponent {

  constructor(@Inject(MAT_DIALOG_DATA) public datos: DatosEdicionPais,
    public dialogRef: MatDialogRef<PaisEditarComponent>,
  ) {

  }

  cerrar() {
    this.dialogRef.close();
  }

}
