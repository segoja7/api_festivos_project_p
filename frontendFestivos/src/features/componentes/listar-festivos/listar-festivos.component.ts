import { Component, Inject } from '@angular/core';
import { Pais } from '../../../shared/entidades/pais';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { FestivoService } from '../../../core/servicios/festivo.service';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { ColumnMode, NgxDatatableModule } from '@swimlane/ngx-datatable';
import { NgFor } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { FestivoDto } from '../../../shared/entidades/festivo-dto';

export interface DatosListarFestivos {
  encabezado: string;
  paises: Pais[];
}

@Component({
  selector: 'app-listar-festivos',
  imports: [
    ReferenciasMaterialModule,
    NgxDatatableModule,
    NgFor,
    FormsModule
  ],
  templateUrl: './listar-festivos.component.html',
  styleUrl: './listar-festivos.component.css'
})
export class ListarFestivosComponent {

  public paisEscogido: Pais | undefined;
  public year: number = (new Date()).getFullYear();
  public fechasFestivas: FestivoDto[] = [];

  public columnas = [
    { name: "Fecha", prop: "fecha" },
    { name: "Festivo", prop: "festivo" },
  ];
  public modoColumna = ColumnMode;

  constructor(@Inject(MAT_DIALOG_DATA) public datos: DatosListarFestivos,
    public dialogRef: MatDialogRef<ListarFestivosComponent>,
    private festivoServicio: FestivoService,
    public dialogServicio: MatDialog,
  ) {

  }

  cerrar() {
    this.dialogRef.close();
  }

  listar() {
    if (this.paisEscogido) {
      this.festivoServicio.obtenerFestivos(this.paisEscogido.id, this.year).subscribe({
        next: response => {
          this.fechasFestivas = response;
        },
        error: error => {
          window.alert(error.message);
        }
      });
    }
    else {
      window.alert("Se debe elegir un País de la lista");
    }

  }

}
