import { Component } from '@angular/core';
import { RouterModule, RouterOutlet } from '@angular/router';
import { ReferenciasMaterialModule } from '../shared/modulos/referencias-material.module';
import { NgFor } from '@angular/common';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, RouterModule,
    ReferenciasMaterialModule,
    NgFor
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent {
  title = 'Festivos';

    public opciones = [
    { titulo: 'Festivos', url: 'festivos', icono: 'iconos/Festivos.png' },
    { titulo: 'Paises', url: 'paises', icono: 'iconos/Paises.png' },
    { titulo: 'Tipos', url: 'tipos', icono: 'iconos/Tipos.png' },
  ];
}
