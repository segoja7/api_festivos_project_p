import { Component, Inject } from '@angular/core';
import { Festivo } from '../../../shared/entidades/festivo';
import { Pais } from '../../../shared/entidades/pais';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';
import { NgFor } from '@angular/common';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Tipo } from '../../../shared/entidades/tipo';

export interface DatosEdicionFestivo {
  encabezado: string;
  festivo: Festivo;
  paises: Pais[];
  tipos: Tipo[];
}

@Component({
  selector: 'app-festivo-editar',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
    NgFor
  ],
  templateUrl: './festivo-editar.component.html',
  styleUrl: './festivo-editar.component.css'
})
export class FestivoEditarComponent {
  constructor(@Inject(MAT_DIALOG_DATA) public datos: DatosEdicionFestivo,
    public dialogRef: MatDialogRef<FestivoEditarComponent>,
  ) {

  }

  cerrar() {
    this.dialogRef.close();
  }

  compararPaises(p1: Pais, p2: Pais): boolean {
    return p1 && p2 ? p1.id === p2.id : p1 === p2;
  }

  compararTipos(t1: Tipo, t2: Tipo): boolean {
    return t1 && t2 ? t1.id === t2.id : t1 === t2;
  }

}
