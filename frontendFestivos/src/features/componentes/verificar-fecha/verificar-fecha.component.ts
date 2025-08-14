import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { FestivoService } from '../../../core/servicios/festivo.service';
import { ReferenciasMaterialModule } from '../../../shared/modulos/referencias-material.module';
import { FormsModule } from '@angular/forms';
import { Pais } from '../../../shared/entidades/pais';
import { NgFor } from '@angular/common';

export interface DatosVerificarFecha {
  encabezado: string;
  paises: Pais[];
}

@Component({
  selector: 'app-verificar-fecha',
  imports: [
    ReferenciasMaterialModule,
    FormsModule,
    NgFor,
  ],
  templateUrl: './verificar-fecha.component.html',
  styleUrl: './verificar-fecha.component.css'
})
export class VerificarFechaComponent {

  public fechaSeleccionada: any;
  public paisEscogido: Pais | undefined;
  public resultado: String = "";

  constructor(@Inject(MAT_DIALOG_DATA) public datos: DatosVerificarFecha,
    public dialogRef: MatDialogRef<VerificarFechaComponent>,
    private festivoServicio: FestivoService,
    public dialogServicio: MatDialog,
  ) {

  }

  cerrar() {
    this.dialogRef.close();
  }

  validarFecha() {
    if (this.paisEscogido) {
      let fecha = new Date(this.fechaSeleccionada);
      this.festivoServicio.verificarFecha(this.paisEscogido.id, fecha).subscribe({
        next: (response: boolean) => {
          if (response) {
            this.resultado = "Es festivo";
          }
          else {
            this.resultado = "No es festivo";
          }
        },
        error: error => {
          this.resultado = error.message;
        }
      });
    }
    else {
      window.alert("Se debe elegir un País de la lista");
    }

  }
}
