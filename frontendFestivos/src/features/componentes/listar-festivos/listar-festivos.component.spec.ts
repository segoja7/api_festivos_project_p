import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ListarFestivosComponent } from './listar-festivos.component';

describe('ListarFestivosComponent', () => {
  let component: ListarFestivosComponent;
  let fixture: ComponentFixture<ListarFestivosComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ListarFestivosComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ListarFestivosComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
